//
//  ApiException.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import UIKit

enum ApiException: LocalizedError {
    case invalidResponse
    case other(bag: ApiErrorBag)
}
