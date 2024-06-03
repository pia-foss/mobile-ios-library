
import Foundation
import NWHttpConnection

@testable import PIALibrary

class NetworkRequestClientMock: NetworkRequestClientType {
    
    var executeRequestCalledAttempt = 0
    var executeRequestError: NetworkRequestError?
    var executeRequestResponse: NetworkRequestResponseType?
    
    func executeRequest(with configuration: NetworkRequestConfigurationType, completion: @escaping Completion) {
        executeRequestCalledAttempt += 1
        completion(executeRequestError, executeRequestResponse)
    }
}
