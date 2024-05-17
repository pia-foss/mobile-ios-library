
import Foundation

public protocol APITokenUseCaseType {
    typealias Completion = (() -> Void)
    func getAPIToken() -> APIToken?
    func refreshAPIToken(completion: APITokenUseCaseType.Completion)
}

class APITokenUseCase: APITokenUseCaseType {
    
    private let apiTokenKey = "API_TOKEN_KEY"
    
    let keychainStore: SecureStore
    let tokenSerializer: AuthTokenSerializerType
    
    init(keychainStore: SecureStore, tokenSerializer: AuthTokenSerializerType) {
        self.keychainStore = keychainStore
        self.tokenSerializer = tokenSerializer
    }
    
    
    public func getAPIToken() -> APIToken? {
        guard let tokenDataString = keychainStore.token(for: apiTokenKey),
              let tokenData = tokenDataString.data(using: .utf8) else { return nil }
        return tokenSerializer.decodeAPIToken(from: tokenData)
    }
    
    public func refreshAPIToken(completion: () -> Void) {
        // TODO: Implement me
        // 1. Call API to refresh API Token
        // 2. Save refreshed token in the keychain
    }
    
    func save(apiToken: APIToken) {
        guard let encodedToken = tokenSerializer.encode(apiToken: apiToken) else { return }
        keychainStore.setPassword(encodedToken, for: apiTokenKey)
    }
    
    
}
