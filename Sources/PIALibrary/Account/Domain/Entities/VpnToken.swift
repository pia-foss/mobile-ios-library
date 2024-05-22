
import Foundation

public struct VpnToken: Codable {
    let username: String
    let password: String
    let expiration: Date
    
    enum CodingKeys: String, CodingKey {
        case username = "vpn_secret1"
        case password = "vpn_secret2"
        case expiration = "expires_at"
    }
    
    var isExpired: Bool {
        expiration.timeIntervalSinceNow.sign == .minus
    }
}

