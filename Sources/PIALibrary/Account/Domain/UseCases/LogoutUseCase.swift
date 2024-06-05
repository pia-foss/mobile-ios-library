
import Foundation

protocol LogoutUseCaseType {
    typealias Completion = ((NetworkRequestError?) -> Void)
    func logout(completion: @escaping Completion)
}

class LogoutUseCase: LogoutUseCaseType {
    
    let networkClient: NetworkRequestClientType
    
    init(networkClient: NetworkRequestClientType) {
        self.networkClient = networkClient
    }
    
    func logout(completion: @escaping Completion) {
            // TODO: Implement me
    }
    
    
}
