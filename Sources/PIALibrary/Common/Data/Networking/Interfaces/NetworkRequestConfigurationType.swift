
import Foundation
import NWHttpConnection

enum NetworkRequestModule {
    case account
}

protocol NetworkRequestConfigurationType {
    var networkRequestModule: NetworkRequestModule { get }
    var path: RequestAPI.Path { get }
    var httpMethod: NWConnectionHTTPMethod { get }
    var inlcudeAuthHeaders: Bool { get }
    var refreshAuthTokensIfNeeded: Bool { get }
    var urlQueryParameters: [String: String]? { get }
    var responseDataType: NWDataResponseType { get }
    var body: Data? { get }
    var timeout: TimeInterval { get }
    var requestQueue: DispatchQueue? { get }
}
