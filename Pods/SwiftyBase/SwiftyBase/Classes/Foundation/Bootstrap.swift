//
//  Bootloader.swift
//  Moco360
//
//  Created by Mark G on 3/27/20.
//  Copyright © 2020 Mobiclix. All rights reserved.
//
#if os(iOS)
import UIKit

public protocol PluginRegisterable: NSObject {
    var isPersistent: Bool { get }
    
    func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
}

public extension PluginRegisterable {
    var isPersistent: Bool { false }
}

public class Bootstrap: NSObject {
    fileprivate var _persistentRegisters = [PluginRegisterable]()
    fileprivate var _appDelegateRegisters: [PluginRegisterable & UIApplicationDelegate] {
        _persistentRegisters
            .filter { $0 is UIApplicationDelegate }
            .map { $0 as! PluginRegisterable & UIApplicationDelegate }
    }
    
    public init(_ plugins: PluginRegisterable.Type...) {
        super.init()
        
        for contructor in plugins {
            
            let register = contructor.init()
            
            /// Store the register that mark `isPersistent = true`
            if register.isPersistent {
                _persistentRegisters.append(register)
            }
        }
    }
    
    public func register(
        application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
        plugins: PluginRegisterable.Type...) {
        
        for contructor in plugins {
            let register = contructor.init()
            
            /// Store the register that mark `isPersistent = true`
            if register.isPersistent {
                _persistentRegisters.append(register)
            }
            
            // Call configure
            register.configure(application: application, launchOptions: launchOptions)
            
        }
    }
}

// MARK: - UIApplicationDelegate
extension Bootstrap: UIApplicationDelegate {
    
    public func applicationWillResignActive(_ application: UIApplication) {
        _appDelegateRegisters.forEach { $0.applicationWillResignActive?(application) }
    }
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        _appDelegateRegisters.forEach { $0.applicationDidEnterBackground?(application) }
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication) {
        _appDelegateRegisters.forEach { $0.applicationWillEnterForeground?(application) }
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
       _appDelegateRegisters.forEach { $0.applicationDidBecomeActive?(application) }
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        _appDelegateRegisters.forEach { $0.applicationWillTerminate?(application) }
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        for delegate in _appDelegateRegisters {
            if #available(iOS 9.0, *) {
                let result = delegate.application?(app, open: url, options: options)
                if result ?? false {
                    return true
                }
            }
        }
        
        return false
    }
    
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        for delegate in _appDelegateRegisters {
            let result = delegate.application?(
                application,
                continue: userActivity,
                restorationHandler: restorationHandler
            )
            
            if result ?? false {
                return true
            }
        }
        
        return false
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        _appDelegateRegisters.forEach {
            $0.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
}
#endif
