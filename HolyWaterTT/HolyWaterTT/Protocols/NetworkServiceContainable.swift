//
//  NetworkServiceContainable.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import Foundation

protocol NetworkServiceContainable {

    associatedtype Service: NetworkSessionProcessable
}

extension NetworkServiceContainable {

    typealias Service = NetworkService
}
