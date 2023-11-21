//
//  DashboardView.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import UIKit

final class DashboardView: BaseView<DashboardViewModel, DashboardOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    let pseudoLaunchView = LaunchView(executionTime: 2.0)
    
    // MARK: -
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemOrange
        
        self.pseudoLaunchView.frame = self.view.bounds
        self.view.addSubview(self.pseudoLaunchView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.pseudoLaunchView.animateProgressBar()
    }
}
