
import Foundation

public protocol LoginUseCaseType {
    typealias Completion = ((NetworkRequestError?) -> Void)
    func login(with credentials: Credentials, completion: @escaping Completion)
}


class LoginUseCase: LoginUseCaseType {
    private let networkClient: NetworkRequestClientType
    private let apiTokenProvider: APITokenProviderType
    private let refreshVpnTokenUseCase: RefreshVpnTokenUseCaseType
    
    init(networkClient: NetworkRequestClientType, apiTokenProvider: APITokenProviderType, refreshVpnTokenUseCase: RefreshVpnTokenUseCaseType) {
        self.networkClient = networkClient
        self.apiTokenProvider = apiTokenProvider
        self.refreshVpnTokenUseCase = refreshVpnTokenUseCase
    }
    
    func login(with credentials: Credentials, completion: @escaping Completion) {
        
        var configuration = LoginRequestConfiguration()
        let credentialsDictionary: [String: String] = [
            "username": credentials.username,
            "password": credentials.password
        ]
        
        if let credentialsData = try? JSONEncoder().encode(credentialsDictionary) {
            configuration.body = credentialsData
        }
        
        networkClient.executeRequest(with: configuration) {[weak self] error, dataResponse in
            
            guard let self else { return }
            
            if let error {
                completion(error)
            } else if let dataResponse {
                self.handleDataResponse(dataResponse, completion: completion)
            } else {
                completion(NetworkRequestError.allConnectionAttemptsFailed)
            }
            
        }
        
        
        
    }
}

private extension LoginUseCase {
    private func handleDataResponse(_ dataResponse: NetworkRequestResponseType, completion: @escaping RefreshVpnTokenUseCaseType.Completion) {
        
        guard let dataResponseContent = dataResponse.data else {
            completion(NetworkRequestError.noDataContent)
            return
        }
        
        do {
            try apiTokenProvider.saveAPIToken(from: dataResponseContent)

            // Refresh the Vpn token after successfully login
           refreshVpnTokenUseCase(with: self.networkClient) { error in
                completion(error)
            }
            
        } catch {
            // TODO: Map error to the ones that the app is expecting/handling
            completion(NetworkRequestError.unableToSaveAPIToken)
        }
    }
}
