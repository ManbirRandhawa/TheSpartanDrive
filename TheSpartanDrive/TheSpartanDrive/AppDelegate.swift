//
//  AppDelegate.swift
//  TheSpartanDrive
//
//  Created by Manbir Randhawa on 5/2/16.
//  Copyright © 2016 CMPE137Group5. All rights reserved.
//

import UIKit
import Parse
import Bolts
import FileBrowser
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Initialize Parse.
        let configuration = ParseClientConfiguration {
            $0.applicationId = "6rd8LKFSsIrqKgdznq6NzMM7z0FOnl8tqZtajb02"
            $0.clientKey = "RSIJUc4b4kQ7DOw7uHhlqCOSMAzKZ4IKqGEk6I9f"
        }
        Parse.initializeWithConfiguration(configuration)
        
        
        Parse.setApplicationId("6rd8LKFSsIrqKgdznq6NzMM7z0FOnl8tqZtajb02", clientKey:"RSIJUc4b4kQ7DOw7uHhlqCOSMAzKZ4IKqGEk6I9f")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        
      
        // Override point for customization after application launch.
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

