

import Foundation

enum UseCaseType {
    case login
    case logout
}

/// Maps an Network Error with a ClientError
/// The idea is to use this mapper on `PIAWebServices` to map the errors returned from the Swift implementation of the Accounts Lib with the ones that the app expects
struct ClientErrorMapper {
    static func map(networkRequestError: NetworkRequestError, useCase: UseCaseType) -> ClientError {
        switch (networkRequestError, useCase) {
        case (.connectionError(let statusCode, let message), _):
            return getClientError(from: statusCode, useCase: useCase) ?? .unexpectedReply
               
        case (.allConnectionAttemptsFailed(let statusCode), _):
            return getClientError(from: statusCode, useCase: useCase) ?? .unexpectedReply
            
        case (.noDataContent, _):
            return .malformedResponseData
            
        case (.noErrorAndNoResponse, _):
            return .unexpectedReply
            
        case (.unableToSaveVpnToken, _):
            return .unexpectedReply
            
        case (.unableToSaveAPIToken, _):
            return .unexpectedReply

        case (.connectionCompletedWithNoResponse, _):
            return .malformedResponseData
            
        case (.unknown(message: let message), _):
            return .unexpectedReply
            
        case (.unableToDecodeAPIToken, _):
            return .malformedResponseData
            
        case (.unableToDecodeVpnToken, _):
            return .malformedResponseData
        }
    }
    
    static func getClientError(from statusCode: Int?, useCase: UseCaseType) -> ClientError? {
        
        guard let statusCode,
              let httpStatusCode = HttpResponseStatusCode(rawValue: statusCode) else {
            return nil
        }
        switch (httpStatusCode, useCase) {
        case (.unauthorized, _):
            return .unauthorized
        case (.throttled, _):
            return .throttled(retryAfter: 60)
        default:
            return nil
        }
    }
    
    
}
