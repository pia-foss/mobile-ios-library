
import Foundation

public protocol VpnTokenUseCaseType {
    typealias Completion = ((AccountAPIError?) -> Void)
    func getVpnToken() -> VpnToken?
    func refreshVpnToken(completion: @escaping VpnTokenUseCaseType.Completion)
}

class VpnTokenUseCase: VpnTokenUseCaseType {
    
    private let vpnTokenKey = "VPN_TOKEN_KEY"
    private let connectionQueue = DispatchQueue(label: "refresh.vpn_token.queue")
    
    let keychainStore: SecureStore
    let tokenSerializer: AuthTokenSerializerType
    let endpointManager: EndpointManagerType
    let accountConnectionRequestProvider: AccountConnectionRequestProviderType
    let accountRequestUseCase: AccountNetworkRequestsUseCaseType
    
    init(keychainStore: SecureStore, tokenSerializer: AuthTokenSerializerType, endpointManager: EndpointManagerType, accountConnectionRequestProvider: AccountConnectionRequestProviderType,
         accountRequestUseCase: AccountNetworkRequestsUseCaseType) {
        self.keychainStore = keychainStore
        self.tokenSerializer = tokenSerializer
        self.endpointManager = endpointManager
        self.accountConnectionRequestProvider = accountConnectionRequestProvider
        self.accountRequestUseCase = accountRequestUseCase
        
    }
    
    public func getVpnToken() -> VpnToken? {
        guard let tokenDataString = keychainStore.token(for: vpnTokenKey),
              let tokenData = tokenDataString.data(using: .utf8) else { return nil }
        return tokenSerializer.decodeVpnToken(from: tokenData)
    }
    
    public func refreshVpnToken(completion: @escaping VpnTokenUseCaseType.Completion) {
        
        let endpoints = endpointManager.availableEndpoints()
        let connections = endpoints.compactMap { endpoint in self.accountConnectionRequestProvider.getAccountConnection(for: endpoint, path: AccountAPI.Path.vpnToken, method: .post, includeAuthHeader: true, body: nil, timeout: 20, queue: connectionQueue)
        }
        
        // Execute the connections in order to refresh the vpn token
        accountRequestUseCase(connections: connections) { [weak self] error, dataResponse in
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
    
    func save(vpnToken: VpnToken) {
        guard let encodedToken = tokenSerializer.encode(vpnToken: vpnToken) else { return }
        keychainStore.setPassword(encodedToken, for: vpnTokenKey)
    }
        
}


private extension VpnTokenUseCase {
    private func handleDataResponse(_ dataResponse: AccountNetworkRequestResponseType, completion: @escaping VpnTokenUseCaseType.Completion) {
        
        guard let dataResponseContent = dataResponse.data else {
            completion(AccountAPIError.noDataContent)
            return
        }
        
        guard let newToken = tokenSerializer.decodeVpnToken(from: dataResponseContent) else {
            completion(AccountAPIError.unableToDecodeVpnToken)
            return
        }
        
        // Save the new vpn token in the Keychain
        save(vpnToken: newToken)
        completion(nil)
    }
    

}
