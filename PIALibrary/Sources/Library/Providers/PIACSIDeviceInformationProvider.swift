//
//  PIACSIDeviceInformationProvider.swift
//  PIALibrary
//
//  Created by Waleed Mahmood on 06.05.22.
//

import Foundation
import PIACSI
import UIKit

class PIACSIDeviceInformationProvider: ICSIProvider {
    
    static let csiDeviceInformationFilename = "device_information"
    
    var filename: String? {
        get {
            return PIACSIDeviceInformationProvider.csiDeviceInformationFilename
        }
    }
    
    var isPersistedData: Bool {
        get {
            return false
        }
    }
    
    var providerType: ProviderType {
        get {
            return ProviderType.deviceInformation
        }
    }
    
    var reportType: ReportType {
        get {
            return ReportType.diagnostic
        }
    }
    
    var value: String? {
        get {
            return getDeviceInformation()
        }
    }
    
    
    func getDeviceInformation() -> String {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
        return "OS Version: \(versionString)\nDevice: \(UIDevice.current.type.rawValue)"
    }
}
