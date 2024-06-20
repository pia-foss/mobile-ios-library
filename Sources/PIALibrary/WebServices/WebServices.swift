//
//  WebServices.swift
//  PIALibrary
//
//  Created by Davide De Rosa on 10/2/17.
//  Copyright © 2020 Private Internet Access, Inc.
//
//  This file is part of the Private Internet Access iOS Client.
//
//  The Private Internet Access iOS Client is free software: you can redistribute it and/or
//  modify it under the terms of the GNU General Public License as published by the Free
//  Software Foundation, either version 3 of the License, or (at your option) any later version.
//
//  The Private Internet Access iOS Client is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
//  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
//  details.
//
//  You should have received a copy of the GNU General Public License along with the Private
//  Internet Access iOS Client.  If not, see <https://www.gnu.org/licenses/>.
//

import Foundation

@available(tvOS 17.0, *)
protocol WebServicesConsumer {
    var webServices: WebServices { get }
}

@available(tvOS 17.0, *)
protocol WebServices: class {
    
    // MARK: Account

    func migrateToken(token: String, _ callback: SuccessLibraryCallback?)

    func update(credentials: Credentials, resetPassword reset: Bool, email: String, _ callback: SuccessLibraryCallback?)

    /// The token to use for protocol authentication.
    var vpnToken: String? { get }

    /// The token to use for api authentication.
    var apiToken: String? { get }
    
    // MARK: DIP Token
    
    func handleDIPTokenExpiration(dipToken: String, _ callback: SuccessLibraryCallback?)
    
    func activateDIPToken(tokens: [String], _ callback: LibraryCallback<[Server]>?) 

    /**
         Deletes the user accout on PIA servers.
         - Parameter callback: Returns an `Bool` if the API returns a success.
     */
    func deleteAccount(_ callback: LibraryCallback<Bool>?)
    
    #if os(iOS) || os(tvOS)
    func signup(with request: Signup, _ callback: LibraryCallback<Credentials>?)
    #endif

    // MARK: Ephemeral

    func downloadServers(_ callback: LibraryCallback<ServersBundle>?)

    func taskForConnectivityCheck(_ callback: LibraryCallback<ConnectivityStatus>?)

    func submitDebugReport(_ shouldSendPersistedData: Bool, _ protocolLogs: String, _ callback: LibraryCallback<String>?)

    func featureFlags(_ callback: LibraryCallback<[String]>?)
}
