
import Foundation
import NWHttpConnection
@testable import PIALibrary

class NWHttpConnectionMock: NWHttpConnectionType {    
    
    var connectionError: NWHttpConnection.NWHttpConnectionError?
    var connectionResponse: NWHttpConnectionDataResponseType?
    var connectionDidCompleteWithoutResponse: Bool = false
    
    func connect(requestHandler: ((NWHttpConnection.NWHttpConnectionError?, NWHttpConnection.NWHttpConnectionDataResponseType?) -> Void)?, completion: (() -> Void)?) throws {
        
        if connectionDidCompleteWithoutResponse {
            completion?()
        } else {
            requestHandler?(connectionError, connectionResponse)
            completion?()
        }
    }    
    
}


