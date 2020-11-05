//
//  JSON.swift
//  SwiftyBase
//
//  Created by Mark G on 7/21/20.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public typealias JSONDict = [String:Any]
public typealias JSONArray = [[String:Any]]
public extension String {
    func toJSONDict() -> JSONDict? {
        guard let data = self.data(using: .utf8) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSONDict
    }
}

public extension Dictionary where Key == String {
    
    func toJSONString() -> String? {
        guard let data = try? JSONSerialization.data(
                withJSONObject: self, options: []
            ) else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
}
