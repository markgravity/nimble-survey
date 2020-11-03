//
//  UserInfo.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import ObjectMapper

struct UserInfo: Equatable {
    
    // Properties
    var email: String!
    var avatarURL: URL!
    
}

// MARK: - Mappble
extension UserInfo: Mappable {
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        email       <- map["attributes.email"]
        avatarURL   <- (map["attributes.avatar_url"], URLTransform())
    }
}
