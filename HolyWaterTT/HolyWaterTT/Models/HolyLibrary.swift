//
//  HolyLibrary.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import Foundation

struct HolyLibrary: Codable {
    
    let books: [Book]
    let topBannerSlides: [TopBannerSlide]
    let youWillLikeSection: [Int]

    enum CodingKeys: String, CodingKey {
        
        case books
        case topBannerSlides = "top_banner_slides"
        case youWillLikeSection = "you_will_like_section"
    }
}
