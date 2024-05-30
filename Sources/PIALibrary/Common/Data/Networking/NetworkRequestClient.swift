
import Foundation
import NWHttpConnection


protocol NetworkRequestClientType {
    typealias Completion = ((NetworkRequestError?, NetworkRequestResponseType?) -> Void)
    func executeRequest(with configuration: NetworkRequestConfigurationType, completion: @escaping Completion)
}


class NetworkRequestClient: NetworkRequestClientType {
    private let networkConnectionRequestProvider: NetworkConnectionRequestProviderType
    private let endpointManager: EndpointManagerType
    private let refreshAuthTokensChecker: RefreshAuthTokensCheckerType
    
    init(networkConnectionRequestProvider: NetworkConnectionRequestProviderType, endpointManager: EndpointManagerType, refreshAuthTokensChecker: RefreshAuthTokensCheckerType) {
        self.networkConnectionRequestProvider = networkConnectionRequestProvider
        self.endpointManager = endpointManager
        self.refreshAuthTokensChecker = refreshAuthTokensChecker
    }
    
    func executeRequest(with configuration: NetworkRequestConfigurationType, completion: @escaping Completion) {

        if configuration.refreshAuthTokensIfNeeded {
            // 1. Refresh the auth tokens before executing the request
            refreshAuthTokensChecker.refreshIfNeeded { error in
                if let error {
                    // The request fails if refreshing the tokens have failed
                    completion(error, nil)
                } else {
                    // 2. Execute the request
                    self.startRequest(with: configuration, completion: completion)
                }
            }
        } else {
            startRequest(with: configuration, completion: completion)
        }
        
    }
    
}

// MARK: - Private

private extension NetworkRequestClient {
    
    func startRequest(with configuration: NetworkRequestConfigurationType, completion: @escaping Completion) {
        let endpoints = getEndpoints(for: configuration.networkRequestModule)
        
        let connections = endpoints.compactMap { endpoint in
            self.networkConnectionRequestProvider.makeNetworkRequestConnection(for: endpoint, with: configuration)
        }
        
        // Runs recursevly all the connections until one succeeds or all fail
        executeRecursivelyUntilSuccess(connections: connections, completion: completion)
    }
    
    /// Serial execution of all the connections until one succeeds or completes with an error when all connection attempts fail
    func executeRecursivelyUntilSuccess(connections:  [NWHttpConnectionType], completion: @escaping NetworkRequestClientType.Completion) {
        
        var remainingConnections = connections
        let nextConnection = remainingConnections.removeFirst()
        
        func tryNextConnectionOrFail() {
            if remainingConnections.isEmpty {
                // No more endpoints to try a connection
                completion(NetworkRequestError.allConnectionAttemptsFailed, nil)
            } else {
                // Continue with the next connection
                executeRecursivelyUntilSuccess(connections: remainingConnections, completion: completion)
            }
        }
        
        execute(connection: nextConnection) { error, responseData in
            if error != nil {
                tryNextConnectionOrFail()
            } else if let responseData {
                let statusCode: Int = responseData.statusCode ?? -1
                let isSuccessStatusCode = statusCode > 199 && statusCode < 300
                if isSuccessStatusCode {
                    completion(nil, responseData)
                } else {
                    // Connection did not succeed, try the next one
                    tryNextConnectionOrFail()
                }
            } else {
                // No error and no data
                tryNextConnectionOrFail()
            }
        }
        
    }
    
    /// Execution of a single connection
    func execute(connection: NWHttpConnectionType, completion: @escaping NetworkRequestClientType.Completion) {
        do {
            var connectionHandled: Bool = false
            
            try connection.connect { error, dataResponse in
                if let error {
                    connectionHandled = true
                    completion(NetworkRequestError.connectionError(message: error.localizedDescription), nil)
                } else if let dataResponse = dataResponse as? NetworkRequestResponseType {
                    connectionHandled = true
                    completion(nil, dataResponse)
                } else {
                    connectionHandled = true
                    completion(NetworkRequestError.noErrorAndNoResponse, nil)
                }
            } completion: {
                if connectionHandled == false {
                    completion(NetworkRequestError.connectionCompletedWithNoResponse, nil)
                }
            }
            
        } catch {
            completion(NetworkRequestError.connectionError(message: error.localizedDescription), nil)
        }
    }
    
    func getEndpoints(for module: NetworkRequestModule) -> [PinningEndpoint] {
        switch module {
        case .account: 
            return endpointManager.availableEndpoints()
        }
    }
}
