
import Foundation

public protocol RefreshVpnTokenUseCaseType {
    typealias Completion = ((AccountAPIError?) -> Void)
    func callAsFunction(completion: @escaping RefreshVpnTokenUseCaseType.Completion)
}

class RefreshVpnTokenUseCase: RefreshVpnTokenUseCaseType {
    
    private let vpnTokenProvider: VpnTokenProviderType
    private let networkClient: NetworkRequestClientType
    
    init(vpnTokenProvider: VpnTokenProviderType,
         networkRequestClient: NetworkRequestClientType) {
        self.vpnTokenProvider = vpnTokenProvider
        self.networkClient = networkRequestClient
    }
    
    func callAsFunction(completion: @escaping RefreshVpnTokenUseCaseType.Completion) {
        
        let configuration = RefreshVpnTokenRequestConfiguration()
        
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


private extension RefreshVpnTokenUseCase {
    private func handleDataResponse(_ dataResponse: NetworkRequestResponseType, completion: @escaping RefreshVpnTokenUseCaseType.Completion) {
        
        guard let dataResponseContent = dataResponse.data else {
            completion(AccountAPIError.noDataContent)
            return
        }
        
        do {
            try vpnTokenProvider.saveVpnToken(from: dataResponseContent)
            completion(nil)
        } catch {
            completion(AccountAPIError.unableToSaveVpnToken)
        }
        
    }
    
}
