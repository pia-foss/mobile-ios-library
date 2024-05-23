
import Foundation
import NWHttpConnection

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
    let accountRequestURLProvider: AccountRequestURLProviderType
    let accountRequestUseCase: AccountNetworkRequestsUseCaseType
    let apiTokenUseCase: APITokenUseCaseType
    
    init(keychainStore: SecureStore, tokenSerializer: AuthTokenSerializerType, endpointManager: EndpointManagerType, accountRequestURLProvider: AccountRequestURLProviderType,
         accountRequestUseCase: AccountNetworkRequestsUseCaseType, apiTokenUseCase: APITokenUseCaseType) {
        self.keychainStore = keychainStore
        self.tokenSerializer = tokenSerializer
        self.endpointManager = endpointManager
        self.accountRequestURLProvider = accountRequestURLProvider
        self.accountRequestUseCase = accountRequestUseCase
        self.apiTokenUseCase = apiTokenUseCase
    }
    
    public func getVpnToken() -> VpnToken? {
        guard let tokenDataString = keychainStore.token(for: vpnTokenKey),
              let tokenData = tokenDataString.data(using: .utf8) else { return nil }
        return tokenSerializer.decodeVpnToken(from: tokenData)
    }
    
    public func refreshVpnToken(completion: @escaping VpnTokenUseCaseType.Completion) {
        
        var endpoints = endpointManager.availableEndpoints()
        let connections = endpoints.compactMap { self.makeRefreshTokenNHttpConnection(for: $0)}
        
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
    private func handleDataResponse(_ dataResponse: NWHttpConnectionDataResponse, completion: @escaping VpnTokenUseCaseType.Completion) {
        
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
    
    func makeCertificateValidation(for endpoint: PinningEndpoint, anchorCertificate: SecCertificate) -> CertificateValidation {
        if endpoint.useCertificatePinning {
            return CertificateValidation.anchor(certificate: anchorCertificate, commonName: endpoint.commonName)
        } else {
            return CertificateValidation.trustedCA
        }
    }
    
    func makeRefreshTokenNHttpConnection(for endpoint: PinningEndpoint) -> NWHttpConnectionType? {
        guard let requestURL = accountRequestURLProvider.getURL(for: endpoint, path: .vpnToken, query: nil) else {
            return nil
        }
        guard let apiToken = apiTokenUseCase.getAPIToken() else {
            return nil
        }
        
        guard let anchorCertificate = AccountAnchorCertificateProvider.getAnchorCertificate() else {
            return nil
        }
        
        let connectionConfiguration = NWConnectionConfiguration(url: requestURL, method: NWConnectionHTTPMethod.post, headers: ["Authorization": "Token \(apiToken.token)"] ,body: nil, certificateValidation: makeCertificateValidation(for: endpoint, anchorCertificate: anchorCertificate), dataResponseType: .jsonData, timeout: 20, queue: connectionQueue)
        
        return NWHttpConnectionFactory.makeNWHttpConnection(with: connectionConfiguration)
        
    }
}
