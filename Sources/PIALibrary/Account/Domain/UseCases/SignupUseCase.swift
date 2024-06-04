
import Foundation

public protocol SignupUseCaseType {
    typealias Completion = ((Result<Credentials, NetworkRequestError>) -> Void)
    func callAsFunction(signup: Signup, completion: @escaping SignupUseCaseType.Completion)
}

class SignupUseCase: SignupUseCaseType {
    private let networkClient: NetworkRequestClientType
    private let signupInformationDataCoverter: SignupInformationDataCoverterType
    
    init(networkClient: NetworkRequestClientType, signupInformationDataCoverter: SignupInformationDataCoverterType) {
        self.networkClient = networkClient
        self.signupInformationDataCoverter = signupInformationDataCoverter
    }
    
    func callAsFunction(signup: Signup, completion: @escaping SignupUseCaseType.Completion) {
        var configuration = SignupRequestConfiguration()
        configuration.body = signupInformationDataCoverter(signup: signup)
        
        networkClient.executeRequest(with: configuration) { [weak self] error, dataResponse in
            guard let self else { return }
            if let error {
                completion(.failure(error))
            } else if let dataResponse {
                self.handleDataResponse(dataResponse, completion: completion)
            } else {
                completion(.failure(NetworkRequestError.allConnectionAttemptsFailed()))
            }
        }
    }
}

private extension SignupUseCase {
    private func handleDataResponse(_ dataResponse: NetworkRequestResponseType, completion: @escaping SignupUseCaseType.Completion) {
        guard let dataResponseContent = dataResponse.data else {
            completion(.failure(NetworkRequestError.noDataContent))
            return
        }
        
        guard let dto = SignUpAccountnformation.makeWith(data: dataResponseContent) else {
            completion(.failure(NetworkRequestError.unableToDecodeDataContent))
            return
        }
        
        completion(.success(dto.toDomainModel()))
    }
}


