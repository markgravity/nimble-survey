//
//  SurveyInfo.swift
//  NimbleSurvey
//
//  Created by Mark G on 01/11/2020.
//

import ObjectMapper

struct SurveyInfo: Equatable {
    
    // Properties
    var title: String!
    var description: String!
    var coverImageURL: URL!
    
}

// MARK: - Mappble
extension SurveyInfo: Mappable {
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        title           <- map["attributes.title"]
        description     <- map["attributes.description"]
        coverImageURL   <- (map["attributes.cover_image_url"], URLTransform())
    }
}
