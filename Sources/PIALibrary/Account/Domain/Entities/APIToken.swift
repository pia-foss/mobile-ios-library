
import Foundation


public struct APIToken: Codable {
    let token: String
    let expiration: Date
    
    enum CodingKeys: String, CodingKey {
        case token = "api_token"
        case expiration = "expires_at"
    }
    
    var isExpired: Bool {
        expiration.timeIntervalSinceNow.sign == .minus
    }
}


