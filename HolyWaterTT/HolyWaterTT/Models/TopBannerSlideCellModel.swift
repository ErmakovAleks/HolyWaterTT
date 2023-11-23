//
//  TopBannerSlideCellModel.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 21.11.2023.
	

import UIKit

enum TopBannerSlideCellModelOutputEvents: Events {
    
    case needLoadPoster(String, BannerCollectionViewCell)
}

struct TopBannerSlideCellModel {
    
    var id: Int
    var bookID: Int
    var cover: String
    
    var handler: (TopBannerSlideCellModelOutputEvents) -> ()
    
    init(
        id: Int,
        bookID: Int,
        cover: String,
        handler: @escaping (TopBannerSlideCellModelOutputEvents) -> Void
    ) {
        self.id = id
        self.bookID = bookID
        self.cover = cover
        self.handler = handler
    }
}
