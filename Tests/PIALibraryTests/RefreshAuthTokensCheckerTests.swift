
import XCTest
@testable import PIALibrary

class RefreshAuthTokensCheckerTests: XCTestCase {
    class Fixture {
        let apiTokenProviderMock = APITokenProviderMock()
        let vpnTokenProviderMock = VpnTokenProviderMock()
        let refreshAPITokenUseCaseMock = RefreshAPITokenUseCaseMock()
        let refreshVpnTokenUseCaseMock = RefreshVpnTokenUseCaseMock()
        
        let expirationDateIn10Days = Calendar.current.date(byAdding: .day, value: 10, to: Date())!
        let expirationDateIn31Days = Calendar.current.date(byAdding: .day, value: 31, to: Date())!
        
        func stubAPIToken(with expirationDate: Date) {
            let apiToken = APIToken(apiToken: "some_api_token", expiresAt: expirationDate)
            apiTokenProviderMock.getAPITokenResult = apiToken
        }
        
        func stubVpnToken(with expirationDate: Date) {
            let vpnToken = VpnToken(vpnUsernameToken: "token_username", vpnPasswordToken: "token_password", expiresAt: expirationDate)
            vpnTokenProviderMock.getVpnTokenResult = vpnToken
        }
        
        func stubRefreshAPIToken(with error: NetworkRequestError?) {
            refreshAPITokenUseCaseMock.completionError = error
        }
        
        func stubRefreshVpnToken(with error: NetworkRequestError?) {
            refreshVpnTokenUseCaseMock.completionError = error
        }
        
        
    }
    
    var fixture: Fixture!
    var sut: RefreshAuthTokensChecker!
    
    override func setUp() {
        fixture = Fixture()
    }
    
    override func tearDown() {
        fixture = nil
        sut = nil
    }
    
    private func instantiateSut() {
        sut = RefreshAuthTokensChecker(apiTokenProvider: fixture.apiTokenProviderMock, vpnTokenProvier: fixture.vpnTokenProviderMock, refreshAPITokenUseCase: fixture.refreshAPITokenUseCaseMock, refreshVpnTokenUseCase: fixture.refreshVpnTokenUseCaseMock)
    }
    
    
    func testRefreshTokensWithSuccess_WhenBothExpireIn10Days() {
        // GIVEN that both the API token and Vpn token will expire in 10 days
        fixture.stubAPIToken(with: fixture.expirationDateIn10Days)
        fixture.stubVpnToken(with: fixture.expirationDateIn10Days)
        
        instantiateSut()
        
        let expectation = expectation(description: "Refresh call is finished")
        var capturedError: NetworkRequestError? = nil
        
        // WHEN calling refresh if needed
        sut.refreshIfNeeded { error in
            capturedError = error
            expectation.fulfill()
        }
        
        // THEN both tokens are refreshed
        XCTAssertEqual(fixture.refreshAPITokenUseCaseMock.callAsFunctionCalledAttempt, 1)
        XCTAssertEqual(fixture.refreshVpnTokenUseCaseMock.callAsFunctionCalledAttempt, 1)
        
        // AND no error is returned
        XCTAssertNil(capturedError)
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testRefreshTokensWithError_WhenBothExpireIn10Days() {
        // GIVEN that both the API token and Vpn token will expire in 10 days
        fixture.stubAPIToken(with: fixture.expirationDateIn10Days)
        fixture.stubVpnToken(with: fixture.expirationDateIn10Days)
        
        // AND GIVEN that refreshing the API token request fails
        fixture.stubRefreshAPIToken(with: .apiTokenNotFound)
        
        instantiateSut()
        
        let expectation = expectation(description: "Refresh call is finished")
        var capturedError: NetworkRequestError? = nil
        
        // WHEN calling refresh if needed
        sut.refreshIfNeeded { error in
            capturedError = error
            expectation.fulfill()
        }
        
        // THEN only the request to refresh the api token is called
        XCTAssertEqual(fixture.refreshAPITokenUseCaseMock.callAsFunctionCalledAttempt, 1)
        XCTAssertEqual(fixture.refreshVpnTokenUseCaseMock.callAsFunctionCalledAttempt, 0)
        
        // AND an error is returned
        XCTAssertNotNil(capturedError)
        
        wait(for: [expectation], timeout: 3)
    }
    
    
    func testRefreshTokens_WhenBothExpireInMoreThan30Days() {
        // GIVEN that both the API token and Vpn token will expire in 31 days
        fixture.stubAPIToken(with: fixture.expirationDateIn31Days)
        fixture.stubVpnToken(with: fixture.expirationDateIn31Days)
        
        instantiateSut()
        
        let expectation = expectation(description: "Refresh call is finished")
        var capturedError: NetworkRequestError? = nil
        
        // WHEN calling refresh if needed
        sut.refreshIfNeeded { error in
            capturedError = error
            expectation.fulfill()
        }
        
        // THEN the tokens don't get refreshed
        XCTAssertEqual(fixture.refreshAPITokenUseCaseMock.callAsFunctionCalledAttempt, 0)
        XCTAssertEqual(fixture.refreshVpnTokenUseCaseMock.callAsFunctionCalledAttempt, 0)
        
        // AND no error is returned
        XCTAssertNil(capturedError)
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testRefreshTokens_WhenAPITokenIsAboutExpiring() {
        // GIVEN that the the API token expires in 10 days
        fixture.stubAPIToken(with: fixture.expirationDateIn10Days)
        // AND that the the Vpn token expires in 31 days
        fixture.stubVpnToken(with: fixture.expirationDateIn31Days)
        
        instantiateSut()
        
        let expectation = expectation(description: "Refresh call is finished")
        var capturedError: NetworkRequestError? = nil
        
        // WHEN calling refresh if needed
        sut.refreshIfNeeded { error in
            capturedError = error
            expectation.fulfill()
        }
        
        // THEN Only the API token is refreshed
        XCTAssertEqual(fixture.refreshAPITokenUseCaseMock.callAsFunctionCalledAttempt, 1)
        XCTAssertEqual(fixture.refreshVpnTokenUseCaseMock.callAsFunctionCalledAttempt, 0)
        
        // AND no error is returned
        XCTAssertNil(capturedError)
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testRefreshTokens_WhenVpnTokenIsAboutExpiring() {
        // GIVEN that the the API token expires in 31 days
        fixture.stubAPIToken(with: fixture.expirationDateIn31Days)
        // AND that the the Vpn token expires in 10 days
        fixture.stubVpnToken(with: fixture.expirationDateIn10Days)
        
        instantiateSut()
        
        let expectation = expectation(description: "Refresh call is finished")
        var capturedError: NetworkRequestError? = nil
        
        // WHEN calling refresh if needed
        sut.refreshIfNeeded { error in
            capturedError = error
            expectation.fulfill()
        }
        
        // THEN Only the Vpn token is refreshed
        XCTAssertEqual(fixture.refreshAPITokenUseCaseMock.callAsFunctionCalledAttempt, 0)
        XCTAssertEqual(fixture.refreshVpnTokenUseCaseMock.callAsFunctionCalledAttempt, 1)
        
        // AND no error is returned
        XCTAssertNil(capturedError)
        
        wait(for: [expectation], timeout: 3)
    }
    
}
