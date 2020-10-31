//
//  ApiErrorBag.swift
//  NimbleSurvey
//
//  Created by Mark G on 29/10/2020.
//

import Foundation
import SwiftyBase
import ObjectMapper

// MARK: - ApiErrorBag
struct ApiErrorBag: Error, Equatable {
    fileprivate(set) var errors: [ApiError]!
    var first: ApiError? {
        errors.first
    }
    
    func hasError(source: ApiErrorSource? = nil, code: ApiErrorCode) -> Bool {
        errors.contains {
            $0.source == source
                && $0.code == code
        }
    }
}

extension ApiErrorBag: Mappable {
    init?(map: Map) {}
    mutating func mapping(map: Map) {
        errors <- map["errors"]
    }
}

// MARK: - ApiError
struct ApiError: Error, Mappable, Equatable {
    var source: ApiErrorSource?
    var code: ApiErrorCode!
    var detail: String!
    
    init(source: ApiErrorSource?, code: ApiErrorCode, detail: String) {
        self.init(JSON: [:])!
        self.source = source
        self.code = code
        self.detail = detail
    }
    
    // Mappable
    init?(map: Map) {}
    mutating func mapping(map: Map) {
        source      <- (map["source"], EnumTransform<ApiErrorSource>())
        code        <- (map["code"], EnumTransform<ApiErrorCode>())
        detail      <- map["detail"]
    }
}

// MARK: - ApiErrorCode
enum ApiErrorCode: String {
    case invalidClient = "invalid_client"
    case invalidToken = "invalid_token"
}

// MARK: - ApiErrorSource
enum ApiErrorSource: String {
    case unauthorized = "unauthorized"
}

