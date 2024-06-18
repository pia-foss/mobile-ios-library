
import Foundation

protocol PaymentUseCaseType {
    typealias Completion = ((NetworkRequestError?) -> Void)
    func processPayment(with credentials: Credentials, request: Payment, completion: @escaping Completion)
}


class PaymentUseCase: PaymentUseCaseType {
    private let networkClient: NetworkRequestClientType
    private let paymentInformationDataConverter: PaymentInformationDataConverterType
    
    init(networkClient: NetworkRequestClientType, paymentInformationDataConverter: PaymentInformationDataConverterType) {
        self.networkClient = networkClient
        self.paymentInformationDataConverter = paymentInformationDataConverter
    }
    
    func processPayment(with credentials: Credentials, request: Payment, completion: @escaping Completion) {
        
        var configuration = PaymentRequestConfiguration()
        
        if let basicAuthHeader = getBasicAuthHeader(for: credentials) {
            configuration.otherHeaders = basicAuthHeader
        }
        
        configuration.body = paymentInformationDataConverter(payment: request)
        
        networkClient.executeRequest(with: configuration) { [weak self] error, dataResponse in
            guard let self else { return }
            NSLog(">>> >>> Execute payment request error: \(error) -- dataResponse: \(dataResponse)")
            if let error {
                self.handleErrorResponse(error, completion: completion)
            } else {
                NSLog(">>> >>> Execute payment response: \(dataResponse)")
                completion(nil)
            }
        }
        
        
    }
    
    
}


private extension PaymentUseCase {
    func getBasicAuthHeader(for credentials: Credentials) -> [String: String]? {
        guard let authHeatherValue = "\(credentials.username):\(credentials.password)".toBase64() else {
            return nil
        }
        
        return ["Authorization" : "Basic \(authHeatherValue)"]
    }
    
    private func handleErrorResponse(_ error: NetworkRequestError, completion: @escaping Completion) {
        if case .connectionError(statusCode: let statusCode, message: let message) = error, statusCode == 400 {
            completion(NetworkRequestError.badReceipt)
            return
        }
        completion(error)
    }
}
