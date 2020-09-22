//
//  AppDelegate.swift
//  AVPlayerP2PSample
//
//  Created by Tiago Pereira on 17/09/2020.
//  Copyright © 2020 NicePeopleAtWork. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = UINavigationController()
        
        if let menuViewController = MenuViewController.initFromXIB() {
            rootViewController.viewControllers = [menuViewController]
        }
        
        window?.rootViewController = rootViewController
        
        
        window?.makeKeyAndVisible()
        
        
        return true
    }
}

