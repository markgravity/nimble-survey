//
//  Exception.swift
//  Moco360
//
//  Created by Mark G on 3/18/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public protocol Exception: Error {
//    var message: String? { get }
}

public struct LocalizedException: Exception {
    public let message: String
}

