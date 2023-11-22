//
//  BookCellModel.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 21.11.2023.
	

import UIKit

enum BookCellModelOutputEvents {
    
    case needPoster(String, UIImageView?)
}

struct BookCellModel {
    
    var id: Int
    var name: String
    var author: String
    var summary: String
    var genre: Genre
    var coverURL: String
    var views: String
    var likes: String
    var quotes: String
    
    var handler: (BookCellModelOutputEvents) -> ()
    
    init(
        id: Int,
        name: String,
        author: String,
        summary: String,
        genre: Genre,
        coverURL: String,
        views: String,
        likes: String,
        quotes: String,
        handler: @escaping (BookCellModelOutputEvents) -> Void
    ) {
        self.id = id
        self.name = name
        self.author = author
        self.summary = summary
        self.genre = genre
        self.coverURL = coverURL
        self.views = views
        self.likes = likes
        self.quotes = quotes
        self.handler = handler
    }
}
