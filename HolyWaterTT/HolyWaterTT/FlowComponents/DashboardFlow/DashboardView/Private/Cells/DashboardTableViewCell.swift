//
//  DashboardTableViewCell.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 21.11.2023.
	

import UIKit
import SnapKit
import RxSwift
import RxRelay

fileprivate extension Constants {
    
    static let itemWidth = 120.0
    static let itemHeight = 190.0
    static let minimumLineSpacing = 8.0
    static let minimumInteritemSpacing = 0.0
    static let horizontalSectionInset = 16.0
    static let verticalSectionInset = 0.0
}

final class DashboardTableViewCell: UITableViewCell {
    
    // MARK: -
    // MARK: Variables
    
    var childNeedAction: ((BookCellModelOutputEvents) -> ())?
    
    private var books = BehaviorRelay<[Book]>(value: [])
    private let disposeBag = DisposeBag()
    
    private var collectionView: UICollectionView?
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: Constants.itemWidth, height: Constants.itemHeight)
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        layout.sectionInset = UIEdgeInsets(
            top: Constants.verticalSectionInset,
            left: Constants.horizontalSectionInset,
            bottom: Constants.verticalSectionInset,
            right: Constants.horizontalSectionInset
        )
        
        return layout
    }()
    
    // MARK: -
    // MARK: TableViewCell Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.prepareBindings()
        self.prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.books.accept([])
    }
    
    // MARK: -
    // MARK: Internal functons
    
    func configure(with models: [Book]) {
        self.books.accept(models)
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepareBindings() {
        self.books.bind { [weak self] _ in
            self?.collectionView?.reloadData()
        }
    }
    
    private func handle(events: BookCellModelOutputEvents) {
        switch events {
        case .needLoadPoster(let url, let cell):
            self.childNeedAction?(.needLoadPoster(url, cell))
        case .needShowDetails(let book):
            self.childNeedAction?(.needShowDetails(book))
        }
    }
    
    private func prepare() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.collectionViewSetup()
        self.collectionViewStyle()
        self.collectionViewLayout()
    }
    
    private func collectionViewSetup() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.register(
            DashboardCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: DashboardCollectionViewCell.self)
        )
        
        self.contentView.addSubview(self.collectionView ?? UIView())
    }
    
    private func collectionViewStyle() {
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.showsHorizontalScrollIndicator = false
    }
    
    private func collectionViewLayout() {
        self.collectionView?.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(Constants.itemHeight)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().inset(12.0)
            $0.bottom.equalToSuperview()
        }
    }
}

extension DashboardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.books.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DashboardCollectionViewCell.self),
            for: indexPath
        ) as? DashboardCollectionViewCell else { return UICollectionViewCell() }
        
        let model = BookCellModel.model(from: self.books.value[indexPath.item]) { [weak self] event in
            self?.handle(events: event)
        }
        
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.handle(events: .needShowDetails(self.books.value[indexPath.item]))
    }
}
