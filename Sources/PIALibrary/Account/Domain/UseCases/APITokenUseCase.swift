
import Foundation
import NWHttpConnection

public protocol APITokenUseCaseType {

    typealias Completion = ((AccountAPIError?) -> Void)
    func getAPIToken() -> APIToken?
    func refreshAPIToken(completion: @escaping APITokenUseCaseType.Completion)
}

class APITokenUseCase: APITokenUseCaseType {
    
    private let apiTokenKey = "API_TOKEN_KEY"
    private let connectionQueue = DispatchQueue(label: "refresh.api_token.queue")
    
    let keychainStore: SecureStore
    let tokenSerializer: AuthTokenSerializerType
    let endpointManager: EndpointManagerType
    let accountRequestURLProvider: AccountRequestURLProviderType
    let accountRequestUseCase: AccountNetworkRequestsUseCaseType
    
    init(keychainStore: SecureStore, tokenSerializer: AuthTokenSerializerType, endpointManager: EndpointManagerType, accountRequestURLProvider: AccountRequestURLProviderType, accountRequestUseCase: AccountNetworkRequestsUseCaseType) {
        self.keychainStore = keychainStore
        self.tokenSerializer = tokenSerializer
        self.endpointManager = endpointManager
        self.accountRequestURLProvider = accountRequestURLProvider
        self.accountRequestUseCase = accountRequestUseCase
    }
    
    
    public func getAPIToken() -> APIToken? {
        guard let tokenDataString = keychainStore.token(for: apiTokenKey),
              let tokenData = tokenDataString.data(using: .utf8) else { return nil }
        return tokenSerializer.decodeAPIToken(from: tokenData)
    }
    
    public func refreshAPIToken(completion: @escaping APITokenUseCaseType.Completion) {
        
        // TODO: Implement me
        // 1. Call API to refresh API Token
        // 2. Save refreshed token in the keychain
    }
    
    func save(apiToken: APIToken) {
        guard let encodedToken = tokenSerializer.encode(apiToken: apiToken) else { return }
        keychainStore.setPassword(encodedToken, for: apiTokenKey)
    }
        
}

