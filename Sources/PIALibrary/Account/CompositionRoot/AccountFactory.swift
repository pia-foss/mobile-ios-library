
import Foundation

public class AccountFactory {
    public static func makeLoginUseCase() -> LoginUseCaseType {
        LoginUseCase(networkClient: NetworkRequestFactory.maketNetworkRequestClient(), apiTokenProvider: makeAPITokenProvider(), refreshVpnTokenUseCase: makeRefreshVpnTokenUseCase())
    }
    
    public static func makeLogoutUseCase() -> LogoutUseCaseType {
        LogoutUseCase(networkClient: NetworkRequestFactory.maketNetworkRequestClient(), apiTokenProvider: makeAPITokenProvider(), vpnTokenProvider: makeVpnTokenProvider(), refreshAuthTokensChecker: makeRefreshAuthTokensChecker())
    }
    
    public static func makeAccountDetailsUseCase() -> AccountDetailsUseCaseType {
        
        AccountDetailsUseCase(networkClient: NetworkRequestFactory.maketNetworkRequestClient(), refreshAuthTokensChecker: makeRefreshAuthTokensChecker(), accountInforDecoder: makeAccountInfoDecoder())
    }
    
    public static func makeSignupUseCase() -> SignupUseCaseType {
        SignupUseCase(networkClient: NetworkRequestFactory.maketNetworkRequestClient(), 
                      signupInformationDataCoverter: SignupInformationDataCoverter())
    }
    
    static func makeDefaultAccountProvider(with webServices: WebServices? = nil) -> DefaultAccountProvider {
        DefaultAccountProvider(webServices: webServices, logoutUseCase: makeLogoutUseCase(), loginUseCase: makeLoginUseCase(), signupUseCase: makeSignupUseCase(), apiTokenProvider: makeAPITokenProvider(), vpnTokenProvider: makeVpnTokenProvider(), accountDetailsUseCase: makeAccountDetailsUseCase())
    }
    
    static func makeRefreshAPITokenUseCase() -> RefreshAPITokenUseCaseType {
        RefreshAPITokenUseCase(apiTokenProvider: makeAPITokenProvider(), networkClient: NetworkRequestFactory.maketNetworkRequestClient())
    }
    
    static func makeRefreshVpnTokenUseCase() -> RefreshVpnTokenUseCaseType {
        RefreshVpnTokenUseCase(vpnTokenProvider: makeVpnTokenProvider(), networkClient: NetworkRequestFactory.maketNetworkRequestClient())
        
    }
    
    static func makeAPITokenProvider() -> APITokenProviderType {
        apitokenProviderShared
    }
    
    static func makeVpnTokenProvider() -> VpnTokenProviderType {
        vpnTokenProviderShared
    }
    
    static func makeRefreshAuthTokensChecker() -> RefreshAuthTokensCheckerType {
        RefreshAuthTokensChecker(apiTokenProvider: makeAPITokenProvider(), vpnTokenProvier: makeVpnTokenProvider(), refreshAPITokenUseCase: makeRefreshAPITokenUseCase(), refreshVpnTokenUseCase: makeRefreshVpnTokenUseCase())
    }
}

// MARK: - Private

private extension AccountFactory {
    
    static var apitokenProviderShared: APITokenProviderType = {
        APITokenProvider(keychainStore: makeSecureStore(), tokenSerializer: makeAuthTokenSerializer())
    }()
    
    static var vpnTokenProviderShared: VpnTokenProviderType = {
        VpnTokenProvider(keychainStore: makeSecureStore(), tokenSerializer: makeAuthTokenSerializer())
    }()
    
    static var secureStoreShared: SecureStore = {
        KeychainStore(team: Client.Configuration.teamId, group: Client.Configuration.appGroup)
    }()
    
    static func makeSecureStore() -> SecureStore {
        secureStoreShared
    }
    
    static func makeAuthTokenSerializer() -> AuthTokenSerializerType {
        AuthTokenSerializer()
    }
    
    static func makeAccountInfoDecoder() -> AccountInfoDecoderType {
        AccountInfoDecoder()
    }
    
}
