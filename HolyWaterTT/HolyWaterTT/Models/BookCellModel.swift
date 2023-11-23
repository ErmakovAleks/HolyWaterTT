//
//  BookCellModel.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 21.11.2023.
	

import UIKit

enum BookCellModelOutputEvents {
    
    case needLoadPoster(String, DashboardCollectionViewCell)
    case needShowDetails(Book)
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
    
    static func model(from book: Book, handler: @escaping (BookCellModelOutputEvents) -> ()) -> Self {
        return BookCellModel(
            id: book.id,
            name: book.name,
            author: book.author,
            summary: book.summary,
            genre: book.genre,
            coverURL: book.coverURL,
            views: book.views,
            likes: book.likes,
            quotes: book.quotes,
            handler: handler
        )
    }
}
