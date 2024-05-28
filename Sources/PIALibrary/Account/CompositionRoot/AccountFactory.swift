
import Foundation

public class AccountFactory {
  
    public static func makeAPITokenUseCase() -> APITokenUseCaseType {
        APITokenUseCase(keychainStore: makeSecureStore(), tokenSerializer: makeAuthTokenSerializer(), endpointManager: makeEndpointManager(), accountRequestURLProvider: makeAccountURLRequestProvider(), accountRequestUseCase: makeAccountNetworkRequestUseCase())
    }
    
    public static func makeVpnTokenUseCase() -> VpnTokenUseCaseType {
        VpnTokenUseCase(keychainStore: makeSecureStore(), tokenSerializer: makeAuthTokenSerializer(), endpointManager: makeEndpointManager(), accountConnectionRequestProvider: makeAccountConnectionRequestProvider(), accountRequestUseCase: makeAccountNetworkRequestUseCase())
    }
    
    static func makeSecureStore() -> SecureStore {
        KeychainStore(team: Client.Configuration.teamId, group: Client.Configuration.appGroup)
    }
    
    static func makeAuthTokenSerializer() -> AuthTokenSerializerType {
        AuthTokenSerializer()
    }
    
    static func makeEndpointManager() -> EndpointManagerType {
        EndpointManager.shared
    }
    
    static func makeAccountURLRequestProvider() -> AccountRequestURLProviderType {
        AccountRequestURLProvider()
    }
    
    static func makeAccountConnectionRequestProvider() -> AccountConnectionRequestProviderType {
        AccountConnectionRequestProvider(apiTokenUseCase: makeAPITokenUseCase(), accountRequestURLProvider: makeAccountURLRequestProvider())
    }
    
    static func makeAccountNetworkRequestUseCase() -> AccountNetworkRequestsUseCaseType {
        AccountNetworkRequestsUseCase()
    }
    
}
