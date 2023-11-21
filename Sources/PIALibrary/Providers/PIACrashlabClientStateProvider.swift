//
//  PIACSIClientStateProvider.swift
//  PIALibrary
//
//  Created by Juan Docal on 9/12/20.
//  Copyright © 2020 London Trust Media. All rights reserved.
//

import Foundation
import csi

class PIACSIClientStateProvider : IEndPointProvider {
    
    var endpoints: [CSIEndpoint] {
        let validEndpoints = EndpointManager.shared.availableCSIEndpoints()
        var clientEndpoints = [CSIEndpoint]()
        for endpoint in validEndpoints {
            clientEndpoints.append(
                CSIEndpoint(
                    endpoint: endpoint.host,
                    isProxy: endpoint.isProxy,
                    usePinnedCertificate: endpoint.useCertificatePinning,
                    certificateCommonName: endpoint.commonName
                )
            )
        }
        return clientEndpoints
    }
}
