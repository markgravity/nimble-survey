//
//  IQKeyboardManagerRegister.swift
//  NimbleSurvey
//
//  Created by Mark G on 02/11/2020.
//

import SwiftyBase
import IQKeyboardManagerSwift

class IQKeyboardManagerRegister: NSObject, PluginRegisterable {
    
    func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        IQKeyboardManager.shared.enable = true
    }
}
