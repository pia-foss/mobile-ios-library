
import Foundation
import NWHttpConnection
@testable import PIALibrary

struct NWHttpConnectionDataResponseMock: NWHttpConnectionDataResponseType {
    var statusCode: Int?
    
    var dataFormat: NWHttpConnection.NWDataResponseType
    
    var data: Data?
    
    init(statusCode: Int? = nil, dataFormat: NWHttpConnection.NWDataResponseType, data: Data? = nil) {
        self.statusCode = statusCode
        self.dataFormat = dataFormat
        self.data = data
    }
    
    
}
