
import Foundation
import NWHttpConnection

struct FeatureFlagsRequestConfiguration: NetworkRequestConfigurationType {
    
    let networkRequestModule: NetworkRequestModule = .account
    let path: RequestAPI.Path = .iosFeatureFlag
    let httpMethod: NWHttpConnection.NWConnectionHTTPMethod = .get
    let contentType: NetworkRequestContentType = .json
    let inlcudeAuthHeaders: Bool = false
    let urlQueryParameters: [String : String]? = nil
    let responseDataType: NWDataResponseType = .jsonData
    
    var otherHeaders: [String : String]? = nil
    var body: Data? = nil
    
    let timeout: TimeInterval = 10
    let requestQueue: DispatchQueue? = DispatchQueue(label: "feature_flags_request.queue")
}



