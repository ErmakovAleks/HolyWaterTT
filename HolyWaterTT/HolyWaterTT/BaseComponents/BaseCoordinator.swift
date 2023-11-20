//
//  BaseCoordinator.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import UIKit
import RxSwift

public class BaseCoordinator: UINavigationController {
    
    // MARK: -
    // MARK: Variables
    
    let disposeBag = DisposeBag()
    
    // MARK: -
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarHidden(true, animated: false)
        self.start()
    }
    
    // MARK: -
    // MARK: Overriding
    
    func start() {}
}
