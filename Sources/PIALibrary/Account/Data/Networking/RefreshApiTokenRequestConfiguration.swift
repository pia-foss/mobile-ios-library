
import Foundation
import NWHttpConnection

struct RefreshApiTokenRequestConfiguration: NetworkRequestConfigurationType {
    let path: RequestAPI.Path = .refreshApiToken
    let httpMethod: NWHttpConnection.NWConnectionHTTPMethod = .post
    let inlcudeAuthHeaders: Bool = true
    let urlQueryParameters: [String : String]? = nil
    let responseDataType: NWDataResponseType = .jsonData
    let body: Data? = nil
    let timeout: TimeInterval = 10
    let requestQueue: DispatchQueue? = DispatchQueue(label: "refresh.api_token.queue")
}
