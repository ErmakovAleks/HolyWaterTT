//
//  ChildCoordinator.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import UIKit
import RxSwift
import RxRelay

public class ChildCoordinator<OutputEventsType: Events>: UIViewController {
    
    // MARK: -
    // MARK: Variables
    
    public var navController = UINavigationController()
    public let disposeBag = DisposeBag()
    
    internal let outputEventsEmiter = PublishRelay<OutputEventsType>()
    public var events: Observable<OutputEventsType> {
        return self.outputEventsEmiter.asObservable()
    }
    
    // MARK: -
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.start()
    }
    
    // MARK: -
    // MARK: Overriding
    
    func start() {}
}
