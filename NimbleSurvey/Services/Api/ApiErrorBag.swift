//
//  ApiErrorBag.swift
//  NimbleSurvey
//
//  Created by Mark G on 29/10/2020.
//

import Foundation
import SwiftyBase
import ObjectMapper

struct ApiErrorBag: Error, Mappable, Equatable {
    fileprivate(set) var errors: [ApiError]!
    var first: ApiError? {
        errors.first
    }
    
    init?(map: Map) {}
    mutating func mapping(map: Map) {
        errors <- map["errors"]
    }
}

// MARK: - ApiError
struct ApiError: Error, Mappable, Equatable {
    var code: ApiErrorCode!
    var detail: String!
    
    init?(map: Map) {}
    mutating func mapping(map: Map) {
        code        <- (map["code"], EnumTransform<ApiErrorCode>())
        detail      <- map["detail"]
    }
}

// MARK: - ApiErrorCode
enum ApiErrorCode: String {
    case invalidClient = "invalid_client"
}

