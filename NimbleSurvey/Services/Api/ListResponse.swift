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
    
    init?(map: Map) {}
    init(items: [E]) {
        self.init(JSON: [:])!
        self.items = items
    }
    
    mutating func mapping(map: Map) {
        items           <- map["data"]
    }
}
