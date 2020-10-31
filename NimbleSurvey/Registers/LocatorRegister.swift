//
//  LocatorRegister.swift
//  anyWidget
//
//  Created by Mark G on 26/09/2020.
//  Copyright © 2020 Mark G. All rights reserved.
//

import SwiftyBase

let locator = baseLocator
class LocatorRegister: NSObject, PluginRegisterable {
    
    override init() {
        super.init()
        
        _registerFactories()
        _registerSingletons()
    }
    
    func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
    }
}

// MARK: - Factories
fileprivate extension LocatorRegister {
    
    func _registerFactories() {
        
        locator.register(HttpService.self) { _ in
            HttpServiceImpl()
        }
    }
}

// MARK: - Singleton
fileprivate extension LocatorRegister {
    
    func _registerSingletons() {
        
        locator.registerSingleton(AuthVM.self, AuthVMImpl())
    }
}
