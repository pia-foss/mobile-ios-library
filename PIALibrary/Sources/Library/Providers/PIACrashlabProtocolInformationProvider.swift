//
//  PIACSIProtocolInformationProvider.swift
//  PIALibrary
//
//  Created by Juan Docal on 9/12/20.
//  Copyright © 2020 London Trust Media. All rights reserved.
//

import Foundation
import PIACSI

class PIACSIProtocolInformationProvider : ICSIProvider {
    static let csiProtocolInformationFilename = "protocol_information"
    var filename: String? {
        get {
            return PIACSIProtocolInformationProvider.csiProtocolInformationFilename
        }
    }
    
    var isPersistedData: Bool {
        get {
            return false
        }
    }
    
    var providerType: ProviderType {
        get {
            return ProviderType.protocolInformation
        }
    }
    
    var reportType: ReportType {
        get {
            return ReportType.diagnostic
        }
    }
    
    var value: String? {
        get {
            return protocolInformation()
        }
    }
    

    private var protocolLogs: String?

    func setProtocolLogs(protocolLogs: String) {
        self.protocolLogs = protocolLogs
    }

    func protocolInformation() -> String {
        protocolLogs = protocolLogs != nil ? protocolLogs : "Unknown"
        return protocolLogs!.redactIPs()
    }
}
