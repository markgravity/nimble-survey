//
//  ListResponse.swift
//  NimbleSurvey
//
//  Created by Mark G on 29/10/2020.
//

import SwiftyBase
import ObjectMapper

struct ListResponse<E: Mappable>: ListResponsable {
    typealias Element = E
    var items: [E] = []
    var nextCursor: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        items           <- map["data"]
        nextCursor      <- map["meta.next_cursor"]
    }
}