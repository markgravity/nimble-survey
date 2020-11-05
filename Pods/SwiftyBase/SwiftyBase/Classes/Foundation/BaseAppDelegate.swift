//
//  BaseAppDelegate.swift
//  SwiftyBase
//
//  Created by Mark G on 6/1/20.
//

#if os(iOS)
open class BaseAppDelegate: UIResponder, UIApplicationDelegate {
    open var window: UIWindow?
    open var bootstrap: Bootstrap!
    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        bootstrap.applicationWillResignActive(application)
    }
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        bootstrap.applicationDidEnterBackground(application)
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        bootstrap.applicationWillEnterForeground(application)
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        bootstrap.applicationDidBecomeActive(application)
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        bootstrap.applicationWillTerminate(application)
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        bootstrap.application(app, open: url, options: options)
    }
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        bootstrap.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        bootstrap.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
    
}
#endif
