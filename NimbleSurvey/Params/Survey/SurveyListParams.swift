//
//  SurveyListParams.swift
//  NimbleSurvey
//
//  Created by Mark G on 01/11/2020.
//

import ObjectMapper
import SwiftyBase

struct SurveyListParams {
    
    // Properties
    let pageNumber: Int
    let pageSize: Int
    
}

// MARK: - HttpParametable
extension SurveyListParams: HttpParametable {
    
    mutating func mapping(map: Map) {
        pageNumber  >>> map["page[number]"]
        pageSize    >>> map["page[size]"]
    }
}
