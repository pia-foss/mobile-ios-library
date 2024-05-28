
import Foundation
import NWHttpConnection
@testable import PIALibrary


struct NetworkRequestConfigurationMock: NetworkRequestConfigurationType {
    
    var path: RequestAPI.Path = .vpnToken
    var httpMethod: NWHttpConnection.NWConnectionHTTPMethod = .get
    var inlcudeAuthHeaders: Bool = true
    var urlQueryParameters: [String : String]? = nil
    var responseDataType: NWHttpConnection.NWDataResponseType = .jsonData
    var body: Data? = nil
    var timeout: TimeInterval = 1
    var requestQueue: DispatchQueue? = nil
    
}
