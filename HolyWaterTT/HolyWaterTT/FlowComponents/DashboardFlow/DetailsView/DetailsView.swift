//
//  DetailsView.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 23.11.2023.
	

import UIKit
import SnapKit
import RxSwift
import RxRelay

fileprivate extension Constants {
    
    static let minimumInteritemSpacing = 0.0
    static let minimumLineSpacing = 0.0
    static let itemHeight = 250.0
    static let itemWidth = 200.0
    
    static let titleFontSize = 20.0
    static let titleLabelTopOffset = 16.0
    static let authorFontSize = 14.0
    static let authorLabelTopOffset = 4.0
    
    static let headCollectionLayoutCoefficient = 1.5
}

final class DetailsView: BaseView<DetailsViewModel, DetailsOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    private var headCollectionView: UICollectionView?
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    
    // MARK: -
    // MARK: Overrided functions
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.viewModel.needReloadHeader.bind { [weak self] in
            self?.headCollectionView?.reloadData()
            guard let book = self?.viewModel.book,
                  let library = self?.viewModel.sortedLibrary[book.genre]
            else { return }
            let index = library.firstIndex(of: book) ?? 0
            
            self?.view.layoutIfNeeded()
            self?.headCollectionView?.scrollToItem(
                at: IndexPath(item: index, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
        }
        .disposed(by: disposeBag)
    }
    
    override func setup() {
        self.navigationBarSetup()
        self.headCollectionViewSetup()
        self.labelsSetup()
    }
    
    override func style() {
        self.view.backgroundColor = .deepPurple
        self.headCollectionViewStyle()
        self.labelsStyle()
    }
    
    override func layout() {
        self.headCollectionViewLayout()
        self.labelsLayout()
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func handle(events: BookCellModelOutputEvents) {
        switch events {
        case .needLoadPoster(let url, let cell):
            self.viewModel.fetchPoster(url: url) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                case .failure(_):
                    cell.imageView.image = UIImage(systemName: "photo")
                }
            }
        case .needShowDetails(_):
            fatalError()
        }
    }
    
    // MARK: -
    // MARK: Prepare Navigation Bar
    
    private func navigationBarSetup() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(self.pop)
        )
        
        self.navigationItem.setLeftBarButton(backButtonItem, animated: false)
        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc private func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -
    // MARK: Prepare HeadCollectionView
    
    private func headCollectionViewSetup() {
        let layout = HeadCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(
            top: 0.0,
            left: (self.view.frame.width - Constants.itemWidth) / 2,
            bottom: 0.0,
            right: (self.view.frame.width - Constants.itemWidth) / 2
        )
        
        layout.itemSize = CGSize(
            width: Constants.itemWidth,
            height: Constants.itemHeight
        )

        self.headCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.headCollectionView?.decelerationRate = .fast
        self.headCollectionView?.delegate = self
        self.headCollectionView?.dataSource = self
        self.headCollectionView?.register(
            HeadCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: HeadCollectionViewCell.self)
        )
        
        self.view.addSubview(self.headCollectionView ?? UICollectionView())
    }
    
    private func headCollectionViewStyle() {
        self.headCollectionView?.backgroundColor = .clear
        self.headCollectionView?.showsHorizontalScrollIndicator = false
    }
    
    private func headCollectionViewLayout() {
        self.headCollectionView?.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(Constants.itemHeight)
        }
    }
    
    // MARK: -
    // MARK: Prepare Labels
    
    private func labelsSetup() {
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.authorLabel)
    }
    
    private func labelsStyle() {
        self.titleLabel.font = .notoSansOriya(size: Constants.titleFontSize)
        self.defaultLabelStyle(for: titleLabel)
        
        self.authorLabel.font = .notoSansOriya(size: Constants.authorFontSize)
        self.defaultLabelStyle(for: authorLabel)
    }
    
    private func defaultLabelStyle(for label: UILabel) {
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.sizeToFit()
    }
    
    private func labelsLayout() {
        self.titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(self.headCollectionView?.snp.bottom ?? 0).offset(Constants.titleLabelTopOffset)
        }
        
        self.authorLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(Constants.authorLabelTopOffset)
        }
    }
}

extension DetailsView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.sortedLibrary[self.viewModel.book.genre]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: HeadCollectionViewCell.self),
            for: indexPath
        ) as? HeadCollectionViewCell else { return UICollectionViewCell() }
        
        if let genreBooks = self.viewModel.sortedLibrary[self.viewModel.book.genre], genreBooks.count > indexPath.item {
            let model = BookCellModel.model(from: genreBooks[indexPath.item]) { [weak self] events in
                self?.handle(events: events)
            }
            
            cell.configure(with: model)
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.headCollectionView {
            let width = scrollView.frame.width
            let index = Int(((scrollView.contentOffset.x + width / 2) * Constants.headCollectionLayoutCoefficient) / width)
            if let genreBooks = self.viewModel.sortedLibrary[self.viewModel.book.genre] {
                self.titleLabel.text = genreBooks[index].name
                self.authorLabel.text = genreBooks[index].author
            }
        }
    }
}

extension DetailsView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200.0, height: 250.0)
    }
}
