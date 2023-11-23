//
//  DetailsView.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 23.11.2023.
	

import UIKit

final class DetailsView: BaseView<DetailsViewModel, DetailsOutputEvents> {
    
    // MARK: -
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemCyan
    }
}
