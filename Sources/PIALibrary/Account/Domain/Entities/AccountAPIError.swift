
import Foundation

public enum AccountAPIError: Error, Equatable {
    case apiTokenNotFound
    case anchorCertificateNotFound
    case connectionError(message: String?)
    case allConnectionAttemptsFailed
    case noDataContent
    case noErrorAndNoResponse
    case unableToDecodeVpnToken
    case unableToSaveVpnToken
    case connectionCompletedWithNoResponse
    case unknown
}
