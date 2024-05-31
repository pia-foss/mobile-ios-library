
import XCTest
import NWHttpConnection
@testable import PIALibrary

class NetworkRequestClientTests: XCTestCase {
    
    class Fixture {
       
        let networkConnectionRequestProviderMock = NetworkConnectionRequestProviderMock()
        let endpointManagerMock = EndpointManagerMock()
        var configurationMock = NetworkRequestConfigurationMock()
        let endpointMock = PinningEndpoint(host: "mock-endpoint")
        let refreshAuthTokensCheckerMock = RefreshAuthTokensCheckerMock()
        
        init() {
        }
        
        func makeSuccessConnection() -> NWHttpConnectionMock {
            let successConnection = NWHttpConnectionMock()
            successConnection.connectionError = nil
            successConnection.connectionResponse = NetworkRequestResponseMock(statusCode: 200)
            
            return successConnection
        }
        
        func makeFailedConnectionWithErrorAndNoResponse() -> NWHttpConnectionMock {
            let failConnectionWithNoResponse = NWHttpConnectionMock()
            failConnectionWithNoResponse.connectionError = NWHttpConnectionError.unknown(NetworkRequestError.unknown)
            failConnectionWithNoResponse.connectionResponse = nil
            return failConnectionWithNoResponse
            
        }
        
        func makeFailedConnecitonWithUnauthorizedResponse() -> NWHttpConnectionMock {
            let failConnectionWithUnAuthorizedResponse = NWHttpConnectionMock()
            failConnectionWithUnAuthorizedResponse.connectionError = nil
            failConnectionWithUnAuthorizedResponse.connectionResponse = NetworkRequestResponseMock(statusCode: 401)
            return failConnectionWithUnAuthorizedResponse
        }
        
        func makeFailedConnectionWithNoErrorAndNoResponse() -> NWHttpConnectionMock {
            let failedConnection = NWHttpConnectionMock()
            failedConnection.connectionDidCompleteWithoutResponse = true
            return failedConnection
        }
        
        
        func stubMakeConnections(connections: [NWHttpConnectionMock]) {
            
            var availableEndpoints = [PinningEndpoint]()
            
            for _ in connections {
                availableEndpoints.append(endpointMock)
            }

            // Stub the same amount of available endpoints as the amount of connections
            endpointManagerMock.availableEndpointsResult = availableEndpoints
            networkConnectionRequestProviderMock.makeNetworkRequestConnectionResults = connections
        }
    }
    
    var fixture: Fixture!
    var sut: NetworkRequestClient!
    
    override func setUp() {
        fixture = Fixture()
    }
    
    override func tearDown() {
        fixture = nil
        sut = nil
    }
    
    private func instantiateSut() {
        sut = NetworkRequestClient(networkConnectionRequestProvider: fixture.networkConnectionRequestProviderMock, endpointManager: fixture.endpointManagerMock, refreshAuthTokensChecker: fixture.refreshAuthTokensCheckerMock)
        
    }
    
    func testMakeSuccessfulRequest_WhenRefreshTokensEnalbed() {
        // GIVEN that the network request config has refresh auth tokens enabled
        fixture.configurationMock.refreshAuthTokensIfNeeded = true
        
        // AND GIVEN that we have 2 successfull connections
        let connection1 = fixture.makeSuccessConnection()
        let connection2 = fixture.makeSuccessConnection()
        
        fixture.stubMakeConnections(connections: [connection1, connection2])
        
        instantiateSut()
        
        let expectation = expectation(description: "The request was executed")
        
        var capturedError: NetworkRequestError?
        var capturedResponse: NetworkRequestResponseType?
        
        // The refresh tokens call has no been executed
        XCTAssertEqual(fixture.refreshAuthTokensCheckerMock.refreshIfNeededCalledAttempt, 0)
        
        // WHEN we execute the request
        sut.executeRequest(with: fixture.configurationMock) { error, dataResponse in
            // THEN the call to refresh the tokens is executed
            XCTAssertEqual(self.fixture.refreshAuthTokensCheckerMock.refreshIfNeededCalledAttempt, 1)
            
            capturedError = error
            capturedResponse = dataResponse
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        
        // AND only the first connection is executed
        XCTAssertEqual(connection1.connectCalledAttempt, 1)
        XCTAssertEqual(connection2.connectCalledAttempt, 0)
        
        // AND No error is returned
        XCTAssertNil(capturedError)
        
        // AND a sucessful response is returned
        XCTAssertNotNil(capturedResponse)
        XCTAssertEqual(capturedResponse!.statusCode!, 200)
    }
    
    func testMakeSuccessfulRequest_AndRefreshTokenDisabled() {
        // GIVEN that the network request config has refresh auth tokens disabled
        fixture.configurationMock.refreshAuthTokensIfNeeded = false
        
        // AND GIVEN that we have 2 connections and the first one succees
        let connection1 = fixture.makeSuccessConnection()
        let connection2 = fixture.makeSuccessConnection()
        
        fixture.stubMakeConnections(connections: [connection1, connection2])
        
        instantiateSut()
        
        let expectation = expectation(description: "The request was executed")
        
        var capturedError: NetworkRequestError?
        var capturedResponse: NetworkRequestResponseType?
        
        // WHEN we execute the request
        sut.executeRequest(with: fixture.configurationMock) { error, dataResponse in
            
            capturedError = error
            capturedResponse = dataResponse
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        // THEN the call to refresh the tokens is NEVER executed
        XCTAssertEqual(self.fixture.refreshAuthTokensCheckerMock.refreshIfNeededCalledAttempt, 0)
        
        // AND only the first connection is executed
        XCTAssertEqual(connection1.connectCalledAttempt, 1)
        XCTAssertEqual(connection2.connectCalledAttempt, 0)
        
        // AND No error is returned
        XCTAssertNil(capturedError)
        
        // AND a sucessful response is returned
        XCTAssertNotNil(capturedResponse)
        XCTAssertEqual(capturedResponse!.statusCode!, 200)
    }
    
    func testMakeRequestWhenFirstConnectionFails() {
        // GIVEN that we have 2 connections and the first one fails
        let connection1 = fixture.makeFailedConnectionWithErrorAndNoResponse()
        let connection2 = fixture.makeSuccessConnection()
        
        fixture.stubMakeConnections(connections: [connection1, connection2])
        
        instantiateSut()
        
        let expectation = expectation(description: "The request was executed")
        
        var capturedError: NetworkRequestError?
        var capturedResponse: NetworkRequestResponseType?
        
        // WHEN we execute the request
        sut.executeRequest(with: fixture.configurationMock) { error, dataResponse in
            capturedError = error
            capturedResponse = dataResponse
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        // THEN the 2 connections are executed
        XCTAssertEqual(connection1.connectCalledAttempt, 1)
        XCTAssertEqual(connection2.connectCalledAttempt, 1)
        
        // AND No error is returned
        XCTAssertNil(capturedError)
        
        // AND a sucessful response is returned
        XCTAssertNotNil(capturedResponse)
        XCTAssertEqual(capturedResponse!.statusCode!, 200)
    }
    
    func testMakeRequestWhenAllConnectionsFail() {
        // GIVEN that we have 2 connections and all of them fail
        let connection1 = fixture.makeFailedConnectionWithErrorAndNoResponse()
        let connection2 = fixture.makeFailedConnecitonWithUnauthorizedResponse()
        
        fixture.stubMakeConnections(connections: [connection1, connection2])
        
        instantiateSut()
        
        let expectation = expectation(description: "The request was executed")
        
        var capturedError: NetworkRequestError?
        var capturedResponse: NetworkRequestResponseType?
        
        // WHEN we execute the request
        sut.executeRequest(with: fixture.configurationMock) { error, dataResponse in
            capturedError = error
            capturedResponse = dataResponse
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        // THEN the 2 connections are executed
        XCTAssertEqual(connection1.connectCalledAttempt, 1)
        XCTAssertEqual(connection2.connectCalledAttempt, 1)
        
        // AND an error is returned
        XCTAssertNotNil(capturedError)
        XCTAssertEqual(capturedError!, NetworkRequestError.allConnectionAttemptsFailed)
        
        // AND a response is not returned
        XCTAssertNil(capturedResponse)
        
    }
    
    func testMakeRequestWhenAllConnectionsFailWithNoErrorAndNoData() {
        // GIVEN that we have 2 connections and all of them fail
        let connection1 = fixture.makeFailedConnectionWithErrorAndNoResponse()
        let connection2 = fixture.makeFailedConnectionWithErrorAndNoResponse()
        
        fixture.stubMakeConnections(connections: [connection1, connection2])
        
        instantiateSut()
        
        let expectation = expectation(description: "The request was executed")
        
        var capturedError: NetworkRequestError?
        var capturedResponse: NetworkRequestResponseType?
        
        // WHEN we execute the request
        sut.executeRequest(with: fixture.configurationMock) { error, dataResponse in
            capturedError = error
            capturedResponse = dataResponse
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
        // THEN the 2 connections are executed
        XCTAssertEqual(connection1.connectCalledAttempt, 1)
        XCTAssertEqual(connection2.connectCalledAttempt, 1)
        
        // AND an error is returned
        XCTAssertNotNil(capturedError)
        XCTAssertEqual(capturedError!, NetworkRequestError.allConnectionAttemptsFailed)
        
        // AND a response is not returned
        XCTAssertNil(capturedResponse)
        
    }
    
}
