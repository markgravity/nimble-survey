//
//  FormDataParameterable.swift
//  Moco360
//
//  Created by Mark G on 5/11/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

import Foundation

public struct FormDataItem {
    let file: URL?
    let data: Data?
    let name: String
    let fileName: String?
    let mimeType: MimeType?
    
    public init(data: Data, name: String, filename: String? = nil, mimeType: MimeType? = nil) {
        self.data = data
        self.name = name
        self.fileName = filename
        self.mimeType = mimeType
        self.file = nil
    }
    
    public init(file: URL, name: String, filename: String? = nil, mimeType: MimeType? = nil) {
        self.data = nil
        self.name = name
        self.fileName = filename
        self.mimeType = mimeType
        self.file = file
    }
}

public protocol FormDataParametable {

    func toFormData() -> [FormDataItem]
}
