//
//  MainCoordinator.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import UIKit
import RxSwift
import RxRelay

final class MainCoordinator: BaseCoordinator {
    
    // MARK: -
    // MARK: Variables
    
    private var dashboardCoordinator: DashboardCoordinator?
    
    // MARK: -
    // MARK: Overrided
    
    override func start() {
        self.dashboardCoordinator = dashboardFlow()
        self.dashboardCoordinator?.navController = self
        
        self.pushViewController(self.dashboardCoordinator ?? UIViewController(), animated: true)
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func dashboardFlow() -> DashboardCoordinator {
        let dashboardCoordinator = DashboardCoordinator()
        dashboardCoordinator.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        return dashboardCoordinator
    }
    
    private func handle(events: DashboardCoordinatorOutputEvents) {
        
    }
}
