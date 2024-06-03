
import Foundation

protocol RefreshVpnTokenUseCaseType {
    typealias Completion = ((NetworkRequestError?) -> Void)
    func callAsFunction(with networkClient: NetworkRequestClientType, completion: @escaping RefreshVpnTokenUseCaseType.Completion)
}

class RefreshVpnTokenUseCase: RefreshVpnTokenUseCaseType {
    
    private let vpnTokenProvider: VpnTokenProviderType
    
    init(vpnTokenProvider: VpnTokenProviderType) {
        self.vpnTokenProvider = vpnTokenProvider
    }
    
    func callAsFunction(with networkClient: NetworkRequestClientType, completion: @escaping RefreshVpnTokenUseCaseType.Completion) {
        
        let configuration = RefreshVpnTokenRequestConfiguration()
        
        networkClient.executeRequest(with: configuration) { [weak self] error, dataResponse in
            NSLog(">>> Refresh vpn token use case, request with config: \(configuration)")
            guard let self else { return }
            NSLog(">>> Refresh vpn token use case, data response: \(dataResponse) -- error: \(error)")
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


private extension RefreshVpnTokenUseCase {
    private func handleDataResponse(_ dataResponse: NetworkRequestResponseType, completion: @escaping RefreshVpnTokenUseCaseType.Completion) {
        
        guard let dataResponseContent = dataResponse.data else {
            completion(NetworkRequestError.noDataContent)
            return
        }
        
        do {
            try vpnTokenProvider.saveVpnToken(from: dataResponseContent)
            completion(nil)
        } catch {
            completion(NetworkRequestError.unableToSaveVpnToken)
        }
        
    }
    
}
