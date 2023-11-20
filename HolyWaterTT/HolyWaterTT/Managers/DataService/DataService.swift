//
//  DataService.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import Foundation
import FirebaseRemoteConfig

final class DataService {
    
    // MARK: -
    // MARK: Variables
    
    private var remoteConfig: RemoteConfig?
    
    var books: [Book]?
    var topBannerSlides: [TopBannerSlide]?
    var youWillLikeSection: [Int]?
    
    // MARK: -
    // MARK: Initialization
    
    init() {
        self.prepareRemoteConfig()
        self.fetchData()
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepareRemoteConfig() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        self.remoteConfig?.configSettings = settings
    }
    
    private func fetchData() {
        self.remoteConfig?.fetch { [weak self] (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self?.remoteConfig?.activate { (changed, error) in
                    let data = self?.remoteConfig?["json_data"].dataValue
                    let model = try? JSONDecoder().decode(HolyLibrary.self, from: data ?? Data())
                    
                    self?.books = model?.books
                    self?.topBannerSlides = model?.topBannerSlides
                    self?.youWillLikeSection = model?.youWillLikeSection
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}
