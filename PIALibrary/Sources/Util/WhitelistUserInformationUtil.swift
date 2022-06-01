//
//  WhitelistUserInformationUtil.swift
//  PIALibrary
//
//  Created by Waleed Mahmood on 31.05.22.
//

import Foundation
import SwiftyBeaver

private let log = SwiftyBeaver.self

public class WhitelistUtil {
    public static func keys() -> [String] {
        let bundle = Bundle(for: WhitelistUtil.self)
        guard let filePath = bundle.path(forResource: "WhitelistUserInformation", ofType: "plist") else {
            log.debug("Couldn't find file 'WhitelistUserInformation.plist'")
            return []
        }
        let contents = NSArray(contentsOfFile: filePath)
        guard let allValues = contents as? [String] else {
            log.debug("Couldn't find whitelist contents in 'WhitelistUserInformation.plist'")
            return []
        }
        return allValues
    }
}
