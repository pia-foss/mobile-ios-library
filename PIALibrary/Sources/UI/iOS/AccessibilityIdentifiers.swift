//
//  AccessibilityIdentifiers.swift
//  PIALibrary
//
//  Created by Waleed Mahmood on 07.03.22.
//

import Foundation

public struct Accessibility {
    public struct UITests {
        public struct Welcome {
            public static let environment = "uitest.welcome.environment"
        }
        public struct Login {
            public static let submit = "uitest.login.submit"
            public static let submitNew = "uitest.login.submit.new"
            public static let username = "uitest.login.username"
            public static let password = "uitest.login.submit"
            public struct Error {
                public static let banner = "uitest.login.error.banner"
            }
        }
        public struct Permissions {
            public static let submit = "uitest.permissions.ok.button"
        }
        public struct Dashboard {
            public static let menu = "uitest.dashboard.menu"
        }
        public struct Menu {
            public static let logout = "uitest.menu.logout"
        }
        public struct Dialog {
            public static let destructive = "uitest.dialog.destructive.button"
        }
    }
}
