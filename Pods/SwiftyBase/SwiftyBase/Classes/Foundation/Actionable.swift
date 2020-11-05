//
//  Actionable.swift
//  SwiftyBase
//
//  Created by Mark G on 6/9/20.
//

import Foundation
import Promises

public protocol Actionable {
    associatedtype ResultType
    func perform() -> Promise<ResultType>
}

public protocol Triggerable: NSObject, Actionable {
    func trigger()
}

