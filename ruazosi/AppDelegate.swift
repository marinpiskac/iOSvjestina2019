//
//  AppDelegate.swift
//  ruazosi
//
//  Created by Marin Piskac on 2019-04-01.
//  Copyright © 2019 Marin Piskač. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = QuizViewControler()
        
        window?.rootViewController = vc
        
        window?.makeKeyAndVisible()
        
        return true
    }
}
