
import Foundation

struct SignInReceiptInformation: Codable {
    let receipt: String
}

extension SignInReceiptInformation {
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
    func toString() -> String? {
        guard let data = self.toData() else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
