
import Foundation

protocol UpdateAccountUseCaseType {
    typealias Completion = ((Result<String, NetworkRequestError>) -> Void)
    
    func setEmail(email: String, resetPassword: Bool, completion: @escaping Completion)
    
    func setEmail(username: String, password: String, email: String, resetPassword: Bool, completion: @escaping Completion)
}


class UpdateAccountUseCase: UpdateAccountUseCaseType {
    
    func setEmail(email: String, resetPassword: Bool, completion: @escaping Completion) {
        
    }
    
    func setEmail(username: String, password: String, email: String, resetPassword: Bool, completion: @escaping Completion) {
        
    }
    
    
}
