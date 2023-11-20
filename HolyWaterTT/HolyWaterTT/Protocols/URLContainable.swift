//
//  URLContainable.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import Foundation

protocol URLContainable {
    
    associatedtype DecodableType: Decodable
    
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get set }
    var body: [String: Any]? { get set }
}

extension URLContainable {
    
    var scheme: String {
        "https"
    }
    
    var host: String {
        "pokeapi.glitch.me"
    }
    
    var method: HTTPMethod {
        .get
    }
}
