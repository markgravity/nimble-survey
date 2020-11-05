//
//  ApiResponse.swift
//  Moco360
//
//  Created by Mark G on 3/19/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

public struct ApiResponse {
    public let response: JSONDict
    
    public init(response: JSONDict) {
        self.response = response
    }
    
    public func asObject<T: Mappable>() -> T {
        return T(JSON: response["data"] as! [String : Any])!
    }
    
    public func asObject<T: Mappable>() -> T? {
        guard let data = response["data"] as? [String : Any]
        else { return nil }
        return T(JSON: data)
    }
    
    public func asList<T: ListResponsable>() -> T {
        
        return T.init(JSON: response)!
    }
    
    public func asVoid()-> Void {
        return;
    }
}
