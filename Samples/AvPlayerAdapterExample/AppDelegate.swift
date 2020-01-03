//
//  AppDelegate.swift
//  AvPlayerAdapterExample
//
//  Created by nice on 16/12/2019.
//  Copyright © 2019 npaw. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = UINavigationController()
        
        rootViewController.viewControllers = [MenuViewController.initFromXIB()]
        
        window?.rootViewController = rootViewController
        
        
        window?.makeKeyAndVisible()
        
        
        return true
    }
}

