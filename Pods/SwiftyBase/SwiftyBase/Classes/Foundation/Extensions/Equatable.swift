//
//  Equatable.swift
//  SwiftyBase
//
//  Created by Mark G on 3/27/20.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public extension Equatable {
    func isAnyOf(_ values: Self...) -> Bool {
        values.filter { $0 == self }.count > 0
    }
}
