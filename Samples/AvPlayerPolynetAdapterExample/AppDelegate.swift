//
//  AppDelegate.swift
//  AvPlayerPolynetAdapterExample
//
//  Created by nice on 09/01/2020.
//  Copyright © 2020 npaw. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = UINavigationController()
        
        let menuViewController = MenuViewController.initFromXIB()
        
        rootViewController.viewControllers = [menuViewController]
        
        window?.rootViewController = rootViewController
        
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

