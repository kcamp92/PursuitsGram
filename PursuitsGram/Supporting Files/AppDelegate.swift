//
//  AppDelegate.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/22/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.7356492877, green: 0.7233195901, blue: 1, alpha: 1)
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.7356492877, green: 0.7233195901, blue: 1, alpha: 1)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

