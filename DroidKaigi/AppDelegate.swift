//
//  AppDelegate.swift
//  DroidKaigi
//
//  Created by kishikawakatsumi on 3/9/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (granted, error) in }
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                print("authorized")
            case .denied:
                print("denied")
            default:
                print("notDetermined")
            }
        }
        
        return true
    }
}
