//
//  DurationTransform.swift
//  SwiftyDuration
//
//  Created by Mark G on 5/19/20.
//  Copyright © 2020 MarkG. All rights reserved.
//

import ObjectMapper

public class DurationTransform: TransformType {
    
    public typealias Object = Duration
    public typealias JSON = Int
    
    fileprivate let unit: DurationUnit
    public init(_ unit: DurationUnit = .seconds) {
        self.unit = unit
    }
    
    public func transformFromJSON(_ value: Any?) -> Duration? {
        var integer: Int?
        if let string = value as? String {
            integer = Int(string)
        }
        
        if let int = value as? Int {
            integer = int
        }
        
        guard let value = integer else { return nil }
        
        switch unit {
        case .milliseconds:
            return .milliseconds(value)
            
        case .seconds:
            return .seconds(value)
            
        case .minutes:
            return .init(minutes: value)
            
        case .hours:
            return .init(hours: value)
            
        case .days:
            return .init(days: value)
        }
    }
    
    public func transformToJSON(_ value: Duration?) -> Int? {
        guard let value = value else { return nil }
        
        switch unit {
        case .milliseconds:
            return value.inMilliseconds
            
        case .seconds:
            return value.inSeconds
            
        case .minutes:
            return value.inMinutes
            
        case .hours:
            return value.inHours
            
        case .days:
            return value.inDays
            
        }
    }
}
