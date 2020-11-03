//
//  UIRegister.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import SwiftyBase

class UIRegister: NSObject, PluginRegisterable {
    
    func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .clear
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true
        
        // Set back button
        UINavigationBar.appearance().backIndicatorImage = UIImage.init(named: "nav-back-white")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage.init(named: "nav-back-white")
        UINavigationBar.appearance().tintColor = .white
    }
}
