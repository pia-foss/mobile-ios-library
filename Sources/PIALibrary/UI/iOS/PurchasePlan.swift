//
//  PurchasePlan.swift
//  PIALibrary
//
//  Created by Davide De Rosa on 10/19/17.
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

class PurchasePlan: NSObject {
    private class DummyInAppProduct: InAppProduct {
        let identifier = ""
        
        let price: NSNumber = 0
        
        let priceLocale = Locale.current
        
        let native: Any? = nil
    }
    
    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.formatterBehavior = .behavior10_4
        f.numberStyle = .currency
        return f
    }()

    private static let accessibleFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.formatterBehavior = .behavior10_4
        f.numberStyle = .currencyPlural
        return f
    }()
    
    static let dummy = PurchasePlan()
    
    var isDummy: Bool {
        return (self == .dummy)
    }
    
    let plan: Plan
    
    let product: InAppProduct
    
    let monthlyFactor: Double
    
    var title = ""

    var detail = ""

    var bestValue = false
    
    var price: NSNumber {
        return product.price
    }
    
    var monthlyPrice: NSNumber {
        return NSDecimalNumber(value: price.doubleValue / monthlyFactor)
    }
    
    var priceString: String {
        return PurchasePlan.string(forPrice: price, locale: product.priceLocale)
    }

    var monthlyPriceString: String {
        return PurchasePlan.string(forPrice: monthlyPrice, locale: product.priceLocale)
    }

    var accessibleMonthlyPriceString: String {
        return PurchasePlan.accessibleString(forPrice: monthlyPrice, locale: product.priceLocale)
    }

    static func string(forPrice price: NSNumber, locale: Locale) -> String {
        formatter.locale = locale
        return formatter.string(from: price)!
    }

    static func accessibleString(forPrice price: NSNumber, locale: Locale) -> String {
        formatter.locale = locale
        return formatter.string(from: price)!
    }
    
    private override init() {
        plan = .trial
        product = DummyInAppProduct()
        monthlyFactor = 1.0
    }

    init(plan: Plan, product: InAppProduct, monthlyFactor: Double) {
        precondition(monthlyFactor > 0.0)
        self.plan = plan
        self.product = product
        self.monthlyFactor = monthlyFactor
    }
    
    // MARK: CustomStringConvertible
    
    public override var description: String {
        return product.identifier
    }
}
