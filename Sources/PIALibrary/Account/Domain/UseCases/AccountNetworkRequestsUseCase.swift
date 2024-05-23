
import Foundation
import NWHttpConnection

protocol AccountNetworkRequestsUseCaseType {
    typealias Completion = ((AccountAPIError?, NWHttpConnectionDataResponse?) -> Void)
    func callAsFunction(connections: [NWHttpConnectionType], completion: @escaping Completion)
}

class AccountNetworkRequestsUseCase: AccountNetworkRequestsUseCaseType {
    func callAsFunction(connections: [NWHttpConnectionType], completion: @escaping AccountNetworkRequestsUseCaseType.Completion) {
        
        var remainingConnections = connections
        let nextConnection = remainingConnections.removeFirst()
        
        func tryNextConnectionOrFail() {
            if remainingConnections.isEmpty {
                // No more endpoints to try a connection
                completion(AccountAPIError.allConnectionAttemptsFailed, nil)
            } else {
                // Continue with the next connection
                callAsFunction(connections: remainingConnections, completion: completion)
            }
        }
        
        execute(connection: nextConnection) { error, responseData in
            if let error {
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

}

// MARK: - Private

private extension AccountNetworkRequestsUseCase {
    private func execute(connection: NWHttpConnectionType, completion: @escaping AccountNetworkRequestsUseCaseType.Completion) {
        do {
            var connectionHandled: Bool = false
            
            try connection.connect { error, dataResponse in
                if let error {
                    connectionHandled = true
                    completion(AccountAPIError.connectionError(message: error.localizedDescription), nil)
                } else if let dataResponse {
                    connectionHandled = true
                    completion(nil, dataResponse)
                } else {
                    connectionHandled = true
                    completion(AccountAPIError.noErrorAndNoResponse, nil)
                }
            } completion: {
                if connectionHandled == false {
                    completion(AccountAPIError.connectionCompletedWithNoResponse, nil)
                }
            }

        } catch {
            completion(AccountAPIError.connectionError(message: error.localizedDescription), nil)
        }
    }
}
