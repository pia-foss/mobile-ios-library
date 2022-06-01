//
//  WhitelistUtil.swift
//  PIALibrary-iOS
//
//  Created by Waleed Mahmood on 01.06.22.
//  Copyright © 2022 London Trust Media. All rights reserved.
//

import Foundation
import SwiftyBeaver

private let log = SwiftyBeaver.self

public class WhitelistUtil {
    public static func keys() -> [String] {
        let bundle = Bundle(for: WhitelistUtil.self)
        guard let filePath = bundle.path(forResource: "WhitelistUserPreferencesKeys", ofType: "plist") else {
            log.debug("Couldn't find file 'WhitelistUserPreferencesKeys.plist'")
            return []
        }
        let contents = NSArray(contentsOfFile: filePath)
        guard let allValues = contents as? [String] else {
            log.debug("Couldn't find whitelist contents in 'WhitelistUserPreferencesKeys.plist'")
            return []
        }
        return allValues
    }
}
