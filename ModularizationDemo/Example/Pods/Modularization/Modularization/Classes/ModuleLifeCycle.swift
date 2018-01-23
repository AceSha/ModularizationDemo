//
//  ModuleLifeCycle.swift
//  Modularization
//
//  Created by sy on 2018/1/18.
//  Copyright © 2018年 iOSWeekWeekUp. All rights reserved.
//
import UIKit

@objc public protocol ModuleLifeCycleDelegate {
    @objc optional func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool

    @objc optional func applicationDidBecomeActive(_ application: UIApplication)

    @objc optional func applicationWillResignActive(_ application: UIApplication)

    @objc optional func applicationDidEnterBackground(_ application: UIApplication)

    @objc optional func applicationWillEnterForeground(_ application: UIApplication)

    @objc optional func applicationWillTerminate(_ application: UIApplication)
    

    @available(iOS, introduced: 2.0, deprecated: 9.0, message: "Please use application:openURL:options:")
    @objc optional func application(_ application: UIApplication, handleOpen url: URL) -> Bool


    @available(iOS, introduced: 4.2, deprecated: 9.0, message: "Please use application:openURL:options:")
    @objc optional func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool


    @available(iOS 9.0, *)
    @objc optional func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool // no equiv. notification. return NO if the application can't open for some reason

    // This callback will be made upon calling -[UIApplication registerUserNotificationSettings:]. The settings the user has granted to the application will be passed in as the second argument.
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenter requestAuthorizationWithOptions:completionHandler:]")
    @objc optional func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings)


    @objc optional func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)


    @objc optional func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)


    @available(iOS, introduced: 3.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications")
    @objc optional func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])


    @available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    @objc optional func application(_ application: UIApplication, didReceive notification: UILocalNotification)


    /*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.

     This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
    @available(iOS 7.0, *)
    @objc optional func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void)


    /// Applications with the "fetch" background mode may be given opportunities to fetch updated content in the background or when it is convenient for the system. This method will be called in these situations. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
    @available(iOS 7.0, *)
    @objc optional func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void)


    // Called when the user activates your application by selecting a shortcut on the home screen,
    // except when -application:willFinishLaunchingWithOptions: or -application:didFinishLaunchingWithOptions returns NO.
    @available(iOS 9.0, *)
    @objc optional func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Swift.Void)


    // Applications using an NSURLSession with a background configuration may be launched or resumed in the background in order to handle the
    // completion of tasks in that session, or to handle authentication. This method will be called with the identifier of the session needing
    // attention. Once a session has been created from a configuration object with that identifier, the session's delegate will begin receiving
    // callbacks. If such a session has already been created (if the app is being resumed, for instance), then the delegate will start receiving
    // callbacks without any action by the application. You should call the completionHandler as soon as you're finished handling the callbacks.
    @available(iOS 7.0, *)
    @objc optional func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Swift.Void)


    // Called on the main thread after the NSUserActivity object is available. Use the data you stored in the NSUserActivity object to re-create what the user was doing.
    // You can create/fetch any restorable objects associated with the user activity, and pass them to the restorationHandler. They will then have the UIResponder restoreUserActivityState: method
    // invoked with the user activity. Invoking the restorationHandler is optional. It may be copied and invoked later, and it will bounce to the main thread to complete its work and call
    // restoreUserActivityState on all objects.
    @available(iOS 8.0, *)
    @objc optional func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool

}

public final class _ModuleLifeCycle {
    var lifeCycles: [ModuleLifeCycleDelegate] = []

    func register(_ array: [String]) {
        lifeCycles = array
            .flatMap{ NSClassFromString($0) as? AppDelegateEntry.Type }
            .map{ $0.init() }
    }
}

extension _ModuleLifeCycle: ModuleLifeCycleDelegate {
    @discardableResult
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        return !lifeCycles
            .flatMap{
                $0.application?(application, didFinishLaunchingWithOptions: launchOptions)
            }
            .contains(false)
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        lifeCycles.forEach{ $0.applicationDidBecomeActive?(application) }
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        lifeCycles.forEach{ $0.applicationWillResignActive?(application) }
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        lifeCycles.forEach{ $0.applicationDidEnterBackground?(application) }
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        lifeCycles.forEach{ $0.applicationWillEnterForeground?(application) }
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        lifeCycles.forEach{ $0.applicationWillEnterForeground?(application) }
    }

    @available(iOS, introduced: 2.0, deprecated: 9.0, message: "Please use application:openURL:options:")
    @discardableResult
    public func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return !lifeCycles
            .flatMap{
                $0.application?(application, handleOpen: url)
            }
            .contains(false)
    }

    @available(iOS, introduced: 4.2, deprecated: 9.0, message: "Please use application:openURL:options:")
    @discardableResult
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return !lifeCycles
            .flatMap{
                $0.application?(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
            }
            .contains(false)
    }

    @available(iOS 9.0, *)
    @discardableResult
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return !lifeCycles
            .flatMap{
                $0.application?(app, open: url, options: options)
            }
            .contains(false)
    }

    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenter requestAuthorizationWithOptions:completionHandler:]")
    public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        lifeCycles.forEach{ $0.application?(application, didRegister: notificationSettings) }
    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        lifeCycles.forEach{ $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) }
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        lifeCycles.forEach{ $0.application?(application, didFailToRegisterForRemoteNotificationsWithError: error) }
    }

    @available(iOS, introduced: 3.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications")
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        lifeCycles.forEach{ $0.application?(application, didReceiveRemoteNotification: userInfo) }
    }

    @available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        lifeCycles.forEach{ $0.application?(application, didReceive: notification) }
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        lifeCycles.forEach{ $0.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler) }
    }

    public func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        lifeCycles.forEach{ $0.application?(application, performFetchWithCompletionHandler: completionHandler) }
    }

    @available(iOS 9.0, *)
    public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Swift.Void) {
        lifeCycles.forEach{ $0.application?(application, performActionFor: shortcutItem, completionHandler: completionHandler) }
    }

    public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Swift.Void) {
        lifeCycles.forEach{ $0.application?(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler) }
    }

    @discardableResult
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool {
        return !lifeCycles
            .flatMap{
                $0.application?(application, continue: userActivity, restorationHandler: restorationHandler)
            }
            .contains(false)
    }
}





