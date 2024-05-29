
import Foundation
import NWHttpConnection

public protocol RefreshAPITokenUseCaseType {
    typealias Completion = ((AccountAPIError?) -> Void)
    func callAsFunction(completion: @escaping RefreshAPITokenUseCaseType.Completion)
}

class RefreshAPITokenUseCase: RefreshAPITokenUseCaseType {
    
    private let apiTokenProvider: APITokenProviderType
    private let networkClient: NetworkRequestClientType
    
    init(apiTokenProvider: APITokenProviderType, networkClient: NetworkRequestClientType) {
        self.apiTokenProvider = apiTokenProvider
        self.networkClient = networkClient
    }
    
    func callAsFunction(completion: @escaping RefreshAPITokenUseCaseType.Completion) {
        
        let configuration = RefreshApiTokenRequestConfiguration()
        
        networkClient.executeRequest(with: configuration) { [weak self] error, dataResponse in
            guard let self else { return }
            
            if let error {
                completion(error)
            } else if let dataResponse {
                self.handleDataResponse(dataResponse, completion: completion)
            } else {
                completion(AccountAPIError.allConnectionAttemptsFailed)
            }
        }
        
    }
    
        
}


private extension RefreshAPITokenUseCase {
    private func handleDataResponse(_ dataResponse: NetworkRequestResponseType, completion: @escaping RefreshVpnTokenUseCaseType.Completion) {
        
        guard let dataResponseContent = dataResponse.data else {
            completion(AccountAPIError.noDataContent)
            return
        }
        
        do {
            try apiTokenProvider.saveAPIToken(from: dataResponseContent)
            completion(nil)
        } catch {
            completion(AccountAPIError.unableToSaveAPIToken)
        }
        
    }
    
}
