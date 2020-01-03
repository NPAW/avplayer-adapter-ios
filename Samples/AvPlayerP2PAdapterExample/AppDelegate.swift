//
//  AppDelegate.swift
//  AvPlayerP2PAdapterExample
//
//  Created by nice on 18/12/2019.
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
        
        let menuViewController = MenuViewController.initFromXIB()
        
        menuViewController.startP2PViewModel()
        //menuViewController.addP2PConfigView()
        
        rootViewController.viewControllers = [menuViewController]
        
        window?.rootViewController = rootViewController
        
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

