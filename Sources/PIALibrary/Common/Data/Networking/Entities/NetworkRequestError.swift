
import Foundation

public enum NetworkRequestError: Error, Equatable {
    case connectionError(statusCode: Int? = nil, message: String? = nil)
    case allConnectionAttemptsFailed(statusCode: Int? = nil)
    case noDataContent
    case noErrorAndNoResponse
    case unableToSaveVpnToken
    case unableToSaveAPIToken
    case unableToDecodeAPIToken
    case unableToDecodeVpnToken
    case connectionCompletedWithNoResponse
    case unknown(message: String? = nil)    
}


enum HttpResponseStatusCode: Int {
    case success = 200
    case throttled = 429
    case unauthorized = 401
}
