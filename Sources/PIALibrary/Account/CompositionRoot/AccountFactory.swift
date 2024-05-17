
import Foundation

public class AccountFactory {
  
    public static func makeAPITokenUseCase() -> APITokenUseCaseType {
        APITokenUseCase(keychainStore: makeSecureStore(), tokenSerializer: makeAuthTokenSerializer())
    }
    
    public static func makeVpnTokenUseCase() -> VpnTokenUseCaseType {
        VpnTokenUseCase(keychainStore: makeSecureStore(), tokenSerializer: makeAuthTokenSerializer())
    }
    
    static func makeSecureStore() -> SecureStore {
        KeychainStore(team: Client.Configuration.teamId, group: Client.Configuration.appGroup)
    }
    
    static func makeAuthTokenSerializer() -> AuthTokenSerializerType {
        AuthTokenSerializer()
    }
}
