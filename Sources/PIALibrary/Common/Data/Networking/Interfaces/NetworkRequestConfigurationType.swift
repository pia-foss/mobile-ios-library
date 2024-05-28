
import Foundation
import NWHttpConnection

protocol NetworkRequestConfigurationType {
    var path: RequestAPI.Path { get }
    var httpMethod: NWConnectionHTTPMethod { get }
    var inlcudeAuthHeaders: Bool { get }
    var urlQueryParameters: [String: String]? { get }
    var responseDataType: NWDataResponseType { get }
    var body: Data? { get }
    var timeout: TimeInterval { get }
    var requestQueue: DispatchQueue? { get }
}
