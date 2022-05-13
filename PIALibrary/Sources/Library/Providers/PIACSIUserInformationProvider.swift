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
    
    var filename: String? { return "user_settings" }
    
    var isPersistedData: Bool { return true }
    
    var providerType: ProviderType { return ProviderType.userSettings }
    
    var reportType: ReportType { return ReportType.diagnostic }
    
    var value: String? { return getUserInformation() }
    
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
