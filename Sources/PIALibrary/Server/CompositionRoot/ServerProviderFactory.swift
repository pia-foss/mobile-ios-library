
import Foundation

class ServerProviderFactory {
    static func makeDefaultServerProvider() -> ServerProvider {
        DefaultServerProvider(renewDedicatedIP: makeRenewDedicatedIPUseCase(),
                              getDedicatedIPs: makeGetDedicatedIPsUseCase(),
                              dedicatedIPServerMapper: makeDedicatedIPServerMapper())
    }
    
    static func makeGetDedicatedIPsUseCase() -> GetDedicatedIPsUseCaseType {
        GetDedicatedIPsUseCase(networkClient: NetworkRequestFactory.maketNetworkRequestClient(), 
                               refreshAuthTokensChecker: AccountFactory.makeRefreshAuthTokensChecker())
    }
    
    public static func makeDedicatedIPServerMapper() -> DedicatedIPServerMapperType {
        DedicatedIPServerMapper(dedicatedIPTokenHandler: makeDedicatedIPTokenHandler())
    }
    
    static func makeDedicatedIPTokenHandler() -> DedicatedIPTokenHandlerType {
        DedicatedIPTokenHandler(secureStore: Client.database.secure)
    }
    
    public static func makeRenewDedicatedIPUseCase() -> RenewDedicatedIPUseCaseType {
        RenewDedicatedIPUseCase(networkClient: NetworkRequestFactory.maketNetworkRequestClient(),
                                refreshAuthTokensChecker: AccountFactory.makeRefreshAuthTokensChecker())
    }
}
