
import Foundation

protocol RefreshAuthTokensCheckerType {
    typealias Completion = ((NetworkRequestError?) -> Void)
    func refreshIfNeeded(with networkClient: NetworkRequestClientType, completion: @escaping Completion)
}

class RefreshAuthTokensChecker: RefreshAuthTokensCheckerType {
    
    let apiTokenProvider: APITokenProviderType
    let vpnTokenProvier: VpnTokenProviderType
    let refreshAPITokenUseCase: RefreshAPITokenUseCaseType
    let refreshVpnTokenUseCase: RefreshVpnTokenUseCaseType
    
    // Number of days remaining before refreshing a token
    private let daysUntilRefresh: Double = 30
    
    init(apiTokenProvider: APITokenProviderType, vpnTokenProvier: VpnTokenProviderType, refreshAPITokenUseCase: RefreshAPITokenUseCaseType, refreshVpnTokenUseCase: RefreshVpnTokenUseCaseType) {
        self.apiTokenProvider = apiTokenProvider
        self.vpnTokenProvier = vpnTokenProvier
        self.refreshAPITokenUseCase = refreshAPITokenUseCase
        self.refreshVpnTokenUseCase = refreshVpnTokenUseCase
    }
    
    func refreshIfNeeded(with networkClient: NetworkRequestClientType, completion: @escaping Completion) {
        
        switch (shouldRefreshApiToken(), shouldRefreshVpnToken()) {
        case (true, true):
            refreshBothTokens(with: networkClient, and: completion)
        case (true, false):
            refreshApiToken(with: networkClient, and: completion)
        case(false, true):
            refreshVpnToken(with: networkClient, and: completion)
        case(false, false):
            completion(nil)
        }
    }
    
}

// MARK: - Refresh tokens helpers

private extension RefreshAuthTokensChecker {
    
    func refreshBothTokens(with networkClient: NetworkRequestClientType, and completion: @escaping Completion) {
        refreshAPITokenUseCase(with: networkClient) { refreshApiTokenError in
            if let refreshApiTokenError {
                completion(refreshApiTokenError)
            } else {
                self.refreshVpnTokenUseCase(with: networkClient) { refreshVpnTokenError in
                    completion(refreshApiTokenError)
                }
            }
        }
    }
    
    func refreshApiToken(with networkClient: NetworkRequestClientType, and completion: @escaping Completion) {
        refreshAPITokenUseCase(with: networkClient) { error in
            completion(error)
        }
    }
    
    func refreshVpnToken(with networkClient: NetworkRequestClientType, and completion: @escaping Completion) {
        refreshVpnTokenUseCase(with: networkClient) { error in
            completion(error)
        }
    }
    
}

// MARK: - Refresh time intervals utils

private extension RefreshAuthTokensChecker {
    
    func shouldRefreshApiToken() -> Bool {
        guard let apiToken = apiTokenProvider.getAPIToken() else {
             return true
        }

        return shouldRefresh(with: apiToken.expiresAt)
    }
    
    func shouldRefreshVpnToken() -> Bool {
        guard let vpnToken = vpnTokenProvier.getVpnToken() else {
             return true
        }
        
        return shouldRefresh(with: vpnToken.expiresAt)
    }
    
    
    func shouldRefresh(with expiration: Date) -> Bool {
        let daysUntilExpires = expiration.timeIntervalSinceNow.inDays()
        
        return daysUntilExpires < daysUntilRefresh
    }
    
}
