//
//  DashboardViewModel.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import UIKit
import RxSwift
import RxRelay

enum DashboardOutputEvents: Events {
    
    case loadingError(RequestError)
}

final class DashboardViewModel: BaseViewModel<DashboardOutputEvents> {
    
    typealias ImageResultCompletion = ResultCompletion<UIImage>
    
    // MARK: -
    // MARK: Variables
    
    private let dataService: DataService
    
    var library = PublishRelay<HolyLibrary>()
    var books = [Book]()
    var topBannerSlides = [TopBannerSlide]()
    var youWillLikeSection = [Int]()
    var genres = [Genre]()
    
    // MARK: -
    // MARK: Initialization
    
    init(dataService: DataService) {
        self.dataService = dataService
        
        super.init()
    }
    
    // MARK: -
    // MARK: Internal functions
    
    private func fetchInitialData() {
        self.dataService.fetchData { [weak self] result in
            switch result {
            case .success(let library):
                self?.library.accept(library)
            case .failure(let error):
                self?.outputEventsEmiter.accept(.loadingError(error))
            }
        }
    }
    
    func fetchPoster(url: String, completion: @escaping ImageResultCompletion) {
        guard let url = URL(string: url) else { return }
        
        Service.sendImageRequest(url: url) { result in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: -
    // MARK: Overrided functions
    
    override func prepareBindings(bag: DisposeBag) {
        self.library.bind {
            self.books = $0.books
            self.topBannerSlides = $0.topBannerSlides
            self.youWillLikeSection = $0.youWillLikeSection
            
            var availableGenres = Set<Genre>()
            $0.books.forEach {
                availableGenres.insert($0.genre)
            }
            
            self.genres = Array(availableGenres)
        }
        .disposed(by: self.disposeBag)
    }
    
    override func viewDidLoaded() {
        super.viewDidLoaded()
        
        self.fetchInitialData()
    }
}
