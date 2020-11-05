//
//  ApiConfigs.swift
//  Moco360
//
//  Created by Mark G on 3/25/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

import Foundation
import Promises

public struct ApiConfigs {
    public static var baseUrl: String!
    public static var token: String? {
        didSet {
            print("Api Token: ", token ?? "")
        }
    }
    public static var retry: ((_ error: Error, _ request: RequestHandler, _ trace: String) throws -> Data) = { error, _, _ in
        throw error
    }
}

