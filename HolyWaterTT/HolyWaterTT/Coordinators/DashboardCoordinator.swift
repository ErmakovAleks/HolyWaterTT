//
//  DashboardCoordinator.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import UIKit
import RxSwift
import RxRelay

enum DashboardCoordinatorOutputEvents: Events {
    
    case needPayment
}

final class DashboardCoordinator: ChildCoordinator {
    
    // MARK: -
    // MARK: Variables
    
    public let events = PublishRelay<DashboardCoordinatorOutputEvents>()
    
    // MARK: -
    // MARK: Coordinator Life Cycle
    
    override func start() {
        super.start()
        
        let viewModel = DashboardViewModel()
        let view = DashboardView(viewModel: viewModel)
        
        viewModel.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        self.navController.pushViewController(view, animated: true)
    }
    
    // MARK: -
    // MARK: Handling Internal Flow Navigation
    
    private func handle(events: DashboardOutputEvents) {
        
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
