
import Foundation

public class AccountFactory {
    public static func makeLoginUseCase() -> LoginUseCaseType {
        LoginUseCase(networkClient: NetworkRequestFactory.maketNetworkRequestClient(), apiTokenProvider: makeAPITokenProvider(), refreshVpnTokenUseCase: makeRefreshVpnTokenUseCase())
    }
    
    public static func makeLogoutUseCase() -> LogoutUseCaseType {
        LogoutUseCase(networkClient: NetworkRequestFactory.maketNetworkRequestClient(), apiTokenProvider: makeAPITokenProvider(), vpnTokenProvider: makeVpnTokenProvider(), refreshAuthTokensChecker: makeRefreshAuthTokensChecker())
    }
    
    static func makeRefreshAPITokenUseCase() -> RefreshAPITokenUseCaseType {
        RefreshAPITokenUseCase(apiTokenProvider: makeAPITokenProvider(), networkClient: NetworkRequestFactory.maketNetworkRequestClient())
    }
    
    static func makeRefreshVpnTokenUseCase() -> RefreshVpnTokenUseCaseType {
        RefreshVpnTokenUseCase(vpnTokenProvider: makeVpnTokenProvider(), networkClient: NetworkRequestFactory.maketNetworkRequestClient())
        
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
