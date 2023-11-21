//
//  UIFont+Extensions.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import UIKit

enum AppFonts: String {
    
    case georgiaBoldItalic = "Georgia Bold Italic"
    case notoSansOriyaBold = "Noto Sans Oriya Bold"
}

extension UIFont {
    
    static func georgiaBoldItalic(size: CGFloat) -> UIFont {
        UIFont(name: AppFonts.georgiaBoldItalic.rawValue, size: size) ?? .boldSystemFont(ofSize: size)
    }
    
    static func notoSansOriyaBold(size: CGFloat) -> UIFont {
        UIFont(name: AppFonts.notoSansOriyaBold.rawValue, size: size) ?? .boldSystemFont(ofSize: size)
    }
}
