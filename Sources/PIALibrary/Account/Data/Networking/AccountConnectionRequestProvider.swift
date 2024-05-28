

import Foundation
import NWHttpConnection

protocol AccountConnectionRequestProviderType {
    func getAccountConnection(for endpoint: PinningEndpoint, path: AccountAPI.Path, method: NWConnectionHTTPMethod, includeAuthHeader: Bool, body: Data?, timeout: TimeInterval, queue: DispatchQueue) -> NWHttpConnectionType?
}


class AccountConnectionRequestProvider: AccountConnectionRequestProviderType {
    let apiTokenUseCase: APITokenUseCaseType
    let accountRequestURLProvider: AccountRequestURLProviderType
    
    init(apiTokenUseCase: APITokenUseCaseType, accountRequestURLProvider: AccountRequestURLProviderType) {
        self.apiTokenUseCase = apiTokenUseCase
        self.accountRequestURLProvider = accountRequestURLProvider
    }
    
    
    func getAccountConnection(for endpoint: PinningEndpoint, path: AccountAPI.Path, method: NWHttpConnection.NWConnectionHTTPMethod, includeAuthHeader: Bool, body: Data?, timeout: TimeInterval, queue: DispatchQueue) -> NWHttpConnection.NWHttpConnectionType? {
        
        guard let requestURL = accountRequestURLProvider.getURL(for: endpoint, path: .vpnToken, query: nil) else {
            return nil
        }

        
        guard let anchorCertificate = AccountAnchorCertificateProvider.getAnchorCertificate() else {
            return nil
        }
        
        var authHeaders: [String: String]?
        if includeAuthHeader {
            guard let apiToken = apiTokenUseCase.getAPIToken() else {
                return nil
            }
            authHeaders = [
                "Authorization": "Token \(apiToken.apiToken)"
            ]
        }
        
        let connectionConfiguration = NWConnectionConfiguration(url: requestURL, method: NWConnectionHTTPMethod.post, headers: authHeaders, body: body, certificateValidation: makeCertificateValidation(for: endpoint, anchorCertificate: anchorCertificate), dataResponseType: .jsonData, timeout: timeout, queue: queue)
        
        return NWHttpConnectionFactory.makeNWHttpConnection(with: connectionConfiguration)
    }
    
}


// MARK: - Private

private extension AccountConnectionRequestProvider {
    
    func makeCertificateValidation(for endpoint: PinningEndpoint, anchorCertificate: SecCertificate) -> CertificateValidation {
        if endpoint.useCertificatePinning {
            return CertificateValidation.anchor(certificate: anchorCertificate, commonName: endpoint.commonName)
        } else {
            return CertificateValidation.trustedCA
        }
    }
    
}
