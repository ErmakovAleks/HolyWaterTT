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
    
    private let dataService = DataService()
    
    // MARK: -
    // MARK: Coordinator Life Cycle
    
    override func start() {
        super.start()
        
        self.navController.pushViewController(self.dashboardView(), animated: true)
    }
    
    // MARK: -
    // MARK: Dashboard Screen
    
    private func dashboardView() -> DashboardView {
        let viewModel = DashboardViewModel(dataService: self.dataService)
        let view = DashboardView(viewModel: viewModel)
        
        viewModel.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        return view
    }
    
    private func handle(events: DashboardOutputEvents) {
        switch events {
        case .loadingError(let error):
            self.showAlert(title: "Error", description: error.localizedDescription)
        case .showDetails(let book, let library):
            self.navController.pushViewController(
                self.detailsView(book: book, library: library),
                animated: true
            )
        }
    }
    
    // MARK: -
    // MARK: Details Screen
    
    private func detailsView(book: Book, library: HolyLibrary) -> DetailsView {
        let viewModel = DetailsViewModel(dataService: self.dataService, book: book, library: library)
        let view = DetailsView(viewModel: viewModel)
        
        viewModel.events.bind { [weak self] in
            self?.handle(events: $0)
        }
        .disposed(by: self.disposeBag)
        
        return view
    }
    
    private func handle(events: DetailsOutputEvents) {
        
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
