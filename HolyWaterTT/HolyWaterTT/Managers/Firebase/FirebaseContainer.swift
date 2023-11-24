//
//  FirebaseContainer.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 24.11.2023.
	

import Foundation
import Firebase
import FirebaseCrashlytics

final class FirebaseContainer {
    
    static let shared = FirebaseContainer()
    
    private(set) var crashlytics: Crashlytics?
    
    private init() { }
    
    // MARK: - Public
    
    func setup() {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.error)
        
        self.configureCrashlytics()
    }
    
    // MARK: - Private
    
    private func configureCrashlytics() {
        self.crashlytics = Crashlytics.crashlytics()
    }
}
