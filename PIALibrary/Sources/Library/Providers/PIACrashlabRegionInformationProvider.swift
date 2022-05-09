//
//  PIACSIRegionInformationProvider.swift
//  PIALibrary
//
//  Created by Juan Docal on 9/12/20.
//  Copyright © 2020 London Trust Media. All rights reserved.
//

import Foundation
import PIACSI

class PIACSIRegionInformationProvider : ICSIProvider {
    static let csiRegionInformationFilename = "regions_information"
    var filename: String? {
        get {
            return PIACSIRegionInformationProvider.csiRegionInformationFilename
        }
    }
    
    var isPersistedData: Bool {
        get {
            return true
        }
    }
    
    var providerType: ProviderType {
        get {
            return ProviderType.regionInformation
        }
    }
    
    var reportType: ReportType {
        get {
            return ReportType.diagnostic
        }
    }
    
    var value: String? {
        get {
            return regionInformation()
        }
    }
    

    func regionInformation() -> String {
        var redactedServers: [String] = []
        for server in Client.providers.serverProvider.currentServers {
            if let redactedServer = Server(
                serial: server.serial,
                name: server.name,
                country: server.country,
                hostname: "REDACTED",
                openVPNAddressesForTCP: nil,
                openVPNAddressesForUDP: nil,
                wireGuardAddressesForUDP: nil,
                iKEv2AddressesForUDP: nil,
                pingAddress: nil,
                responseTime: nil,
                geo: server.geo,
                offline: server.offline,
                latitude: server.latitude,
                longitude: server.longitude,
                meta: nil,
                dipExpire: nil,
                dipToken: nil,
                dipStatus: nil,
                dipUsername: nil,
                regionIdentifier: server.regionIdentifier
            ).toJSON()?.description {
                redactedServers.append(redactedServer)
            }
        }
        return redactedServers.debugDescription.redactIPs()
    }
}
