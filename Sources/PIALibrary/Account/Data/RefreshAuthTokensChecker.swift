
import Foundation

protocol RefreshAuthTokensCheckerType {
    typealias Completion = ((NetworkRequestError?) -> Void)
    func refreshIfNeeded(completion: @escaping Completion)
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
    
    func refreshIfNeeded(completion: @escaping Completion) {
        
        switch (shouldRefreshApiToken(), shouldRefreshVpnToken()) {
        case (true, true):
            refreshBothTokens(with: completion)
        case (true, false):
            refreshApiToken(with: completion)
        case(false, true):
            refreshVpnToken(with: completion)
        case(false, false):
            completion(nil)
        }
    }
    
}

// MARK: - Refresh tokens helpers

private extension RefreshAuthTokensChecker {
    
    func refreshBothTokens(with completion: @escaping Completion) {
        refreshAPITokenUseCase() { refreshApiTokenError in
            if let refreshApiTokenError {
                completion(refreshApiTokenError)
            } else {
                self.refreshVpnTokenUseCase() { refreshVpnTokenError in
                    if let refreshVpnTokenError {
                        completion(refreshVpnTokenError)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func refreshApiToken(with completion: @escaping Completion) {
        refreshAPITokenUseCase() { error in
            self.handleRefreshResponse(with: error, completion: completion)
        }
    }
    
    func refreshVpnToken(with completion: @escaping Completion) {
        refreshVpnTokenUseCase() { error in
            self.handleRefreshResponse(with: error, completion: completion)
        }
    }
    
    func handleRefreshResponse(with error: NetworkRequestError?, completion: @escaping Completion) {
        if let error {
            completion(error)
        } else {
            completion(nil)
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
