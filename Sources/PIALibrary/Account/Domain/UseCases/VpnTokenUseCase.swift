
import Foundation

public protocol VpnTokenUseCaseType {
    typealias Completion = (() -> Void)
    func getVpnToken() -> VpnToken?
    func refreshVpnToken(completion: VpnTokenUseCaseType.Completion)
}

class VpnTokenUseCase: VpnTokenUseCaseType {
    
    private let vpnTokenKey = "VPN_TOKEN_KEY"
    
    let keychainStore: SecureStore
    let tokenSerializer: AuthTokenSerializerType
    
    init(keychainStore: SecureStore, tokenSerializer: AuthTokenSerializerType) {
        self.keychainStore = keychainStore
        self.tokenSerializer = tokenSerializer
    }
    
    public func getVpnToken() -> VpnToken? {
        guard let tokenDataString = keychainStore.token(for: vpnTokenKey),
              let tokenData = tokenDataString.data(using: .utf8) else { return nil }
        return tokenSerializer.decodeVpnToken(from: tokenData)
    }
    
    public func refreshVpnToken(completion: () -> Void) {
        // TODO: Implement me
        // 1. Call API to refresh Vpn Token
        // 2. Save refreshed token in the keychain
    }
    
    func save(vpnToken: VpnToken) {
        guard let encodedToken = tokenSerializer.encode(vpnToken: vpnToken) else { return }
        keychainStore.setPassword(encodedToken, for: vpnTokenKey)
    }
    
    
}
