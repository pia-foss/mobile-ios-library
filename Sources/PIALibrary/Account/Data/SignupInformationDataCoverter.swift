
import Foundation

class SignupInformationDataCoverter: SignupInformationDataCoverterType {
    func callAsFunction(signup: Signup) -> Data? {
        let signupInformation = SignupInformation(store: "apple_app_store",
                                                  receipt: signup.receipt.base64EncodedString(),
                                                  email: signup.email,
                                                  marketing: stringify(json: signup.marketing),
                                                  debug: stringify(json: signup.debug))
        
        return signupInformation.toData()
    }
    
    private func stringify(json: [String: Any]?, prettyPrinted: Bool = false) -> String? {
        guard let json else {
            return nil
        }
        
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
            print(error)
        }

        return nil
    }
}
