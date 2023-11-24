//
//  AppDelegate.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseContainer.shared.setup()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .deepPurple
        window?.rootViewController = MainCoordinator()
        window?.makeKeyAndVisible()
        
        return true
    }
}

