
import Foundation

public class AccountFactory {
    
    public static func makeRefreshAPITokenUseCase() -> RefreshAPITokenUseCaseType {
        RefreshAPITokenUseCase(apiTokenProvider: makeAPITokenProvider(), networkClient: NetworkRequestFactory.maketNetworkRequestClient())
    }
    
    public static func makeRefreshVpnTokenUseCase() -> RefreshVpnTokenUseCaseType {
        RefreshVpnTokenUseCase(vpnTokenProvider: makeVpnTokenProvider(), networkRequestClient: NetworkRequestFactory.maketNetworkRequestClient())
        
    }
    
    static func makeAPITokenProvider() -> APITokenProviderType {
        APITokenProvider(keychainStore: makeSecureStore(), tokenSerializer: makeAuthTokenSerializer())
    }
    
    static func makeVpnTokenProvider() -> VpnTokenProviderType {
        VpnTokenProvider(keychainStore: makeSecureStore(), tokenSerializer: makeAuthTokenSerializer())
    }
    
    static func makeRefreshAuthTokensChecker() -> RefreshAuthTokensCheckerType {
        RefreshAuthTokensChecker(apiTokenProvider: makeAPITokenProvider(), vpnTokenProvier: makeVpnTokenProvider(), refreshAPITokenUseCase: makeRefreshAPITokenUseCase(), refreshVpnTokenUseCase: makeRefreshVpnTokenUseCase())
    }
}

// MARK: - Private

private extension AccountFactory {
    
    static func makeSecureStore() -> SecureStore {
        KeychainStore(team: Client.Configuration.teamId, group: Client.Configuration.appGroup)
    }
    
    static func makeAuthTokenSerializer() -> AuthTokenSerializerType {
        AuthTokenSerializer()
    }
    
}
