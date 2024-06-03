
import Foundation
@testable import PIALibrary

class RefreshAPITokenUseCaseMock: RefreshAPITokenUseCaseType {
    
    var callAsFunctionCalledAttempt = 0
    var completionError: NetworkRequestError?
    
    func callAsFunction(with networkClient: NetworkRequestClientType, completion: @escaping ((NetworkRequestError?) -> Void)) {
        callAsFunctionCalledAttempt += 1
        completion(completionError)
    }
}
