//
//  Book.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import Foundation

struct Book: Codable {
    
    let id: Int
    let name: String
    let author: String
    let summary: String
    let genre: Genre
    let coverURL: String
    let views: String
    let likes: String
    let quotes: String

    enum CodingKeys: String, CodingKey {
        
        case id, name, author, summary, genre, views, likes, quotes
        case coverURL = "cover_url"
    }
}

enum Genre: String, Codable {
    
    case fantasy = "Fantasy"
    case science = "Science"
    case romance = "Romance"
}
