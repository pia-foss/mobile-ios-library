//
//  PIACSIUserInformationProvider.swift
//  PIALibrary
//
//  Created by Waleed Mahmood on 05.05.22.
//  Copyright © 2020 London Trust Media. All rights reserved.
//

import Foundation
import PIACSI

class PIACSIUserInformationProvider: ICSIProvider {
    
    static let csiUserSettingsFilename = "user_settings"
    
    var filename: String? {
        get {
            return PIACSIUserInformationProvider.csiUserSettingsFilename
        }
    }
    
    var isPersistedData: Bool {
        get {
            return true
        }
    }
    
    var providerType: ProviderType {
        get {
            return ProviderType.userSettings
        }
    }
    
    var reportType: ReportType {
        get {
            return ReportType.diagnostic
        }
    }
    
    var value: String? {
        get {
            return getUserInformation()
        }
    }
    
    func getUserInformation() -> String {
        var userSettings = ""
        guard let defaults = UserDefaults(suiteName: Client.Configuration.appGroup) else {
            return userSettings
        }
        for (key, value) in defaults.dictionaryRepresentation() {
            userSettings += "\(key): \(value)\n"
        }
        return userSettings.redactIPs()
    }
}
