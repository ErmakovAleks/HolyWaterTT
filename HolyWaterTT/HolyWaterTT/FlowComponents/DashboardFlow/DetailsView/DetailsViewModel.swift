//
//  DetailsViewModel.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 23.11.2023.
	

import UIKit
import RxSwift
import RxRelay

enum DetailsOutputEvents: Events {
    
    case loadingError(RequestError)
    case showDetails(Book, HolyLibrary)
    case read(Book)
}

final class DetailsViewModel: BaseViewModel<DetailsOutputEvents> {
    
    typealias ImageResultCompletion = ResultCompletion<UIImage>
    
    // MARK: -
    // MARK: Variables
    
    let needReloadHeader = PublishRelay<Void>()
    
    private let dataService: DataService
    private let library: HolyLibrary
    let book: Book
    
    var books = [Book]()
    var topBannerSlides = [TopBannerSlide]()
    var youWillLikeSection = [Int]()
    var genres = [Genre]()
    var sortedLibrary = [Genre : [Book]]()
    var recommended = [Book]()
    
    // MARK: -
    // MARK: Initialization
    
    init(dataService: DataService, book: Book, library: HolyLibrary) {
        self.dataService = dataService
        self.library = library
        self.book = book
        
        super.init()
        
        self.prepareInitialData()
    }
    
    // MARK: -
    // MARK: Internal functions
    
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
    
    func showDetails(for book: Book) {
        self.outputEventsEmiter.accept(.showDetails(book, self.library))
    }
    
    func read(book: Book) {
        self.outputEventsEmiter.accept(.read(book))
    }
    
    // MARK: -
    // MARK: Overrided functions
    
    override func viewDidLoaded() {
        super.viewDidLoaded()
        
        self.needReloadHeader.accept(())
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepareInitialData() {
        self.books = self.library.books
        self.topBannerSlides = self.library.topBannerSlides
        self.youWillLikeSection = self.library.youWillLikeSection
        
        var availableGenres = Set<Genre>()
        
        self.library.books.forEach {
            availableGenres.insert($0.genre)
            if self.sortedLibrary[$0.genre] == nil {
                self.sortedLibrary[$0.genre] = [$0]
            } else {
                self.sortedLibrary[$0.genre]?.append($0)
            }
        }
        
        self.recommended = self.library.books.filter { self.youWillLikeSection.contains($0.id) }
        
        self.genres = Array(availableGenres)
    }
}
