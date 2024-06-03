
import Foundation
import NWHttpConnection

protocol RefreshAPITokenUseCaseType {
    typealias Completion = ((NetworkRequestError?) -> Void)
    func callAsFunction(with networkClient: NetworkRequestClientType, completion: @escaping RefreshAPITokenUseCaseType.Completion)
}

class RefreshAPITokenUseCase: RefreshAPITokenUseCaseType {
    
    private let apiTokenProvider: APITokenProviderType
    
    init(apiTokenProvider: APITokenProviderType) {
        self.apiTokenProvider = apiTokenProvider
    }
    
    func callAsFunction(with networkClient: NetworkRequestClientType, completion: @escaping RefreshAPITokenUseCaseType.Completion) {
        
        let configuration = RefreshApiTokenRequestConfiguration()
        
        networkClient.executeRequest(with: configuration) { [weak self] error, dataResponse in
            guard let self else { return }
            
            if let error {
                completion(error)
            } else if let dataResponse {
                self.handleDataResponse(dataResponse, completion: completion)
            } else {
                completion(NetworkRequestError.allConnectionAttemptsFailed)
            }
        }
        
    }
    
        
}


private extension RefreshAPITokenUseCase {
    private func handleDataResponse(_ dataResponse: NetworkRequestResponseType, completion: @escaping RefreshVpnTokenUseCaseType.Completion) {
        
        guard let dataResponseContent = dataResponse.data else {
            completion(NetworkRequestError.noDataContent)
            return
        }
        
        do {
            try apiTokenProvider.saveAPIToken(from: dataResponseContent)
            completion(nil)
        } catch {
            completion(NetworkRequestError.unableToSaveAPIToken)
        }
        
    }
    
}
