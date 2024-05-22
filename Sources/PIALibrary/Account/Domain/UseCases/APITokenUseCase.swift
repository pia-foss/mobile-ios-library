
import Foundation
import NWHttpConnection

public protocol APITokenUseCaseType {
    typealias Completion = (() -> Void)
    func getAPIToken() -> APIToken?
    func refreshAPIToken(completion: APITokenUseCaseType.Completion)
}

class APITokenUseCase: APITokenUseCaseType {
    
    private let apiTokenKey = "API_TOKEN_KEY"
    
    let keychainStore: SecureStore
    let tokenSerializer: AuthTokenSerializerType
    let endpointManager: EndpointManagerType
    let accountRequestURLProvider: AccountRequestURLProviderType
    
    
    init(keychainStore: SecureStore, tokenSerializer: AuthTokenSerializerType, endpointManager: EndpointManagerType, accountRequestURLProvider: AccountRequestURLProviderType) {
        self.keychainStore = keychainStore
        self.tokenSerializer = tokenSerializer
        self.endpointManager = endpointManager
        self.accountRequestURLProvider = accountRequestURLProvider
    }
    
    
    public func getAPIToken() -> APIToken? {
        guard let tokenDataString = keychainStore.token(for: apiTokenKey),
              let tokenData = tokenDataString.data(using: .utf8) else { return nil }
        return tokenSerializer.decodeAPIToken(from: tokenData)
    }
    
    public func refreshAPIToken(completion: () -> Void) {
        let endpoints = endpointManager.availableEndpoints()
        for endpoint in endpoints {
            let requestURL = accountRequestURLProvider.getURL(for: endpoint, path: .refreshToken, query: nil)
            
        }
        // TODO: Implement me
        // 1. Call API to refresh API Token
        // 2. Save refreshed token in the keychain
    }
    
    func save(apiToken: APIToken) {
        guard let encodedToken = tokenSerializer.encode(apiToken: apiToken) else { return }
        keychainStore.setPassword(encodedToken, for: apiTokenKey)
    }
    
    
}
