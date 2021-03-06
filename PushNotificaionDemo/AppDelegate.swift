//
//  AppDelegate.swift
//  PushNotificaionDemo
//
//  Created by Vikash Kumar on 04/04/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var appStateString = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        pushNotificationSettings()
        //UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func pushNotificationSettings() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        UIApplication.shared.registerForRemoteNotifications()
        setActions()
    }
    
    func setActions() {
        let pusherWeb = UNNotificationAction(
            identifier: "accept",
            title: "Accept Invitation"
        )
        let reply = UNTextInputNotificationAction(
            identifier: "invitationReply",
            title: "Reply",
            textInputButtonTitle: "Send",
            textInputPlaceholder: "Type here..."
        )
        
        let dismiss = UNNotificationAction(
            identifier: "dismiss",
            title: "Dismiss",
            options: [.destructive]
        )
        
    
        
        let category = UNNotificationCategory(
            identifier: "invitation",
            actions: [pusherWeb, dismiss],
            intentIdentifiers: []
        )
        let categoryReply = UNNotificationCategory(
            identifier: "invitationReply",
            actions: [pusherWeb, reply, dismiss],
            intentIdentifiers: []
        )

        
        UNUserNotificationCenter.current().setNotificationCategories([category, categoryReply])
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1) })
        print("Device Token String : \(tokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Device token register error : \(error.localizedDescription)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //completionHandler(.newData)
        print("Received Push Payload Info : \(userInfo)")
        switch application.applicationState {
        case .active:
            appStateString = "Active"
            print("AppState : Active")
        case .inactive:
            appStateString = "InActive"
            print("AppState : InActive")
        case .background:
            appStateString = "Backgound"
            print("AppState : Background")
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationReceive"), object: nil)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    //category custom action
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

