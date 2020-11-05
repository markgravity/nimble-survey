//
//  SKProduct.swift
//  Moco360
//
//  Created by Mark G on 10/1/18.
//  Copyright © 2018 Mobiclix. All rights reserved.
//

import StoreKit

public extension SKProduct {
    
    var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }
    
    @available(iOS 11.2, *)
    var localizedMonthlyPrice: String? {
        guard
            let unit = self.subscriptionPeriod?.unit,
            var numberOfUnit = self.subscriptionPeriod?.numberOfUnits,
            unit.isAnyOf(.month, .year)
        else { return nil }
        
        numberOfUnit = unit == .year ? 12 : numberOfUnit
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        
        let pricePerUnit = price.doubleValue / Double(numberOfUnit)
        return formatter.string(from: NSNumber(value: pricePerUnit))
    }
    
}

@available(iOS 11.2, *)
extension SKProductDiscount {
    
    var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }
    
    var trialDurationText: String {
        let numberOfUnits = subscriptionPeriod.numberOfUnits
        let unitText = subscriptionPeriod.unitString
        let numberOfUnitsText = numberOfUnits == 1 ?  "a" : "\(numberOfUnits)"
        return "\(numberOfUnitsText) \(unitText)"
    }
}

@available(iOS 11.2, *)
extension SKProductSubscriptionPeriod {
    var unitString: String {
        var text = ""
        switch unit {
        case .day:
            text += numberOfUnits > 1 ? "days" : "day"
            
        case .month:
            text += numberOfUnits > 1 ? "months" : "month"
            
        case .year:
            text += numberOfUnits > 1 ? "years" : "year"
            
        case .week:
            text += numberOfUnits > 1 ? "weeks" : "week"
        @unknown default:
            break
        }
        
        return text
    }
    
    var numberAndUnitString: String {
        guard numberOfUnits > 1 else {
            return unitString
        }
        
        return "\(numberOfUnits) \(unitString)"
    }
}
