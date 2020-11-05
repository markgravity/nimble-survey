//
//  ApiListResponsable.swift
//  Moco360
//
//  Created by Mark G on 3/18/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//
import Foundation
import ObjectMapper

public protocol ListResponsable: Mappable {
    associatedtype Element: Mappable
    var items: [Element] { get set }
}

//public class ListResponse<E: Mappable>: ListResponsable {
//    public required init?(map: Map) {
//        self.items = []
//    }
//    
//    
//    public typealias Element = E
//    public let items: [E]
//    
//    
//    public init(items: [E] = [E]()) {
//        self.items = items
//    }
//    
//    public func mapping(map: Map) {
//        items >>> map["data"]
//    }
//}
