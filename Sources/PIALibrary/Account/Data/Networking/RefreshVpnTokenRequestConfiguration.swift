
import Foundation
import NWHttpConnection

struct RefreshVpnTokenRequestConfiguration: NetworkRequestConfigurationType {
    let path: RequestAPI.Path = .vpnToken
    let httpMethod: NWHttpConnection.NWConnectionHTTPMethod = .post
    let inlcudeAuthHeaders: Bool = true
    let urlQueryParameters: [String : String]? = nil
    let responseDataType: NWDataResponseType = .jsonData
    let body: Data? = nil
    let timeout: TimeInterval = 10
    let requestQueue: DispatchQueue? = DispatchQueue(label: "refresh.vpn_token.queue")
}
