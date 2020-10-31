//
//  L10nPluginRegister.swift
//  Moco360
//
//  Created by Mark G on 3/27/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//

import UIKit
import L10n_swift
import SwiftyBase

class L10nRegister: NSObject, PluginRegisterable {
    
    var isPersistent: Bool = false
    
    
    
    func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
        // Language
        if let langCode = UserDefaults.standard.object(forKey: "current_language") as? String {
            L10n.shared.language = langCode
        }
    }
}
