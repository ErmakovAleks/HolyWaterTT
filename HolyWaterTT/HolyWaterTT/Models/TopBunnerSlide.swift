//
//  TopBunnerSlide.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import Foundation

struct TopBannerSlide: Codable {
    
    let id: Int
    let bookID: Int
    let cover: String

    enum CodingKeys: String, CodingKey {
        
        case id
        case bookID = "book_id"
        case cover
    }
}
