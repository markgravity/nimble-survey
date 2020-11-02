//
//  ApiException.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import UIKit

enum ApiException: LocalizedError, Equatable {
    case invalidResponse
    case other(bag: ApiErrorBag)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "api.invalid_response_error_msg".trans()
        case .other(let errorBag):
            return errorBag.errorDescription
        }
    }
}
