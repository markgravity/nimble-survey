//
//  MimeType.swift
//  Moco360
//
//  Created by Mark G on 8/16/18.
//  Copyright © 2018 Mobiclix. All rights reserved.
//

import Foundation

public enum MimeType: String {
    case bitmap = "image/bmp"
    case gif = "image/gif"
    case jpeg = "image/jpeg"
    case tif = "image/tiff"
    case png = "image/png"
    
    public var ext: String {
        switch self {
        case .bitmap:
            return "bmp"
        case .gif:
            return "gif"
            
        case .jpeg:
            return "jpg"
            
        case .tif:
            return "tiff"
            
        case .png:
            return "png"
        }
    }
    
    public init?(ext: String) {
        switch ext.lowercased() {
        case "bmp":
            self = .bitmap
            
        case "gif":
            self = .gif
            
        case "jpe", "jpeg", "jpg":
            self = .jpeg
            
        case "tif", "tiff":
            self = .tif
            
        case "png":
            self = .png
            
        default:
            return nil
        }
    }
}
