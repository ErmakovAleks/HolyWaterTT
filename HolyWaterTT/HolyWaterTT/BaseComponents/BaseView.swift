//
//  BaseView.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import UIKit

import RxSwift
import RxCocoa

public class BaseView<ViewModelType, OutputEventsType>: UIViewController
where ViewModelType: BaseViewModel<OutputEventsType>, OutputEventsType: Events
{
    // MARK: -
    // MARK: Accesors
    
    public var events: Observable<OutputEventsType> {
        return self.viewModel.events
    }
    
    internal let viewModel: ViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: -
    // MARK: Initializations
    
    public init(viewModel: ViewModelType, nibName: String? = nil, bundle: Bundle? = nil) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: ViewController Life Cylce
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.style()
        self.layout()
        
        self.prepareBindings(disposeBag: self.disposeBag)
        self.prepare(with: self.viewModel)
        self.viewModel.viewDidLoaded()
    }
    
    //MARK: -
    //MARK: Overrding methods
    
    func setup() {
        
    }
    
    func style() {
        
    }
    
    func layout() {
        
    }
    
    func prepareBindings(disposeBag: DisposeBag) {
        
    }
    
    func prepare(with viewModel: ViewModelType) {
        
    }
}
