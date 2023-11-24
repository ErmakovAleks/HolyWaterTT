//
//  InfoBoardView.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 24.11.2023.
	

import UIKit
import SnapKit

fileprivate extension Constants {
    
    static let containerSpacing = 10.0
    static let containerVerticalInsets = 20.0
    static let containerHorizontalInsets = 0.0
    
    static let headerContainerVerticalInsets = 0.0
    static let headerContainerHorizontalInsets = 34.0
    
    static let collectionTitleHeight = 34.0
    static let collectionTitleInset = 16.0
    
    static let itemHeight = 190.0
    static let itemWidth = 120.0
    static let minimumLineSpacing = 8.0
    static let minimumInteritemSpacing = 0.0
    static let verticalSectionInset = 0.0
    static let horizontalSectionInset = 16.0
    
    static let readNowButtonHeight = 48.0
    static let readNowButtonHorizontalInsets = 48.0
    static let readNowButtonTopInset = 14.0
}

final class InfoBoardView: UIView {
    
    // MARK: -
    // MARK: Variables
    
    var handler: ((Book) -> ())?
    
    private var book: Book?
    private var recommended: [Book]?
    private var childNeedAction: ((BookCellModelOutputEvents) -> ())?
    
    private let headerContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: Constants.headerContainerVerticalInsets,
            left: Constants.headerContainerHorizontalInsets,
            bottom: Constants.headerContainerVerticalInsets,
            right: Constants.headerContainerHorizontalInsets
        )
        
        return stackView
    }()
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.containerSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: Constants.containerVerticalInsets,
            left: Constants.containerHorizontalInsets,
            bottom: Constants.containerVerticalInsets,
            right: Constants.containerHorizontalInsets
        )
        
        return stackView
    }()
    
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
    
    private let collectionTitleView: UIView = {
        let label = UILabel()
        label.text = "You will also like"
        label.font = UIFont.notoSansOriyaBold(size: 20.0)
        label.textColor = .almostBlack
        label.textAlignment = .left
        label.sizeToFit()
        
        let view = UIView()
        view.addSubview(label)
        
        view.snp.makeConstraints {
            $0.height.equalTo(Constants.collectionTitleHeight)
        }
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.collectionTitleInset)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        return view
    }()
    
    private let scrollView = UIScrollView()
    private var summaryView: SummaryView?
    private var collectionView: UICollectionView?
    private let readNowButtonView = UIView()
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Internal functions
    
    func configure(with book: Book, and recommended: [Book], completion: @escaping (BookCellModelOutputEvents) -> ()) {
        self.book = book
        self.recommended = recommended
        self.childNeedAction = completion
        
        self.prepare()
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepare() {
        self.prepareScrollView()
        self.prepareHeaderContainer()
        self.prepareSummaryView()
        self.prepareCollection()
        self.prepareReadNowButton()
        self.prepareContainer()
    }
    
    private func handle(events: BookCellModelOutputEvents) {
        switch events {
        case .needLoadPoster(let url, let cell):
            self.childNeedAction?(.needLoadPoster(url, cell))
        case .needShowDetails(let book):
            self.childNeedAction?(.needShowDetails(book))
        }
    }
    
    private func prepareScrollView() {
        self.scrollView.showsVerticalScrollIndicator = true
        
        self.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.scrollView.addSubview(self.container)
        
        self.container.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(self.scrollView.snp.width)
        }
    }
    
    private func prepareHeaderContainer() {
        self.headerContainer.removeAllArrangedSubviews()
        
        guard let book else { return }
        var headerArray = [
            InfoBoardHeaderItemView(title: book.views, type: .readers),
            InfoBoardHeaderItemView(title: book.likes, type: .likes),
            InfoBoardHeaderItemView(title: book.quotes, type: .quotes)
        ]
        
        book.genre == .romance
            ? headerArray.append(InfoBoardHeaderItemView(title: book.genre.rawValue, type: .genre, image: UIImage(named: "hotPepper")))
            : headerArray.append(InfoBoardHeaderItemView(title: book.genre.rawValue, type: .genre))
        
        headerArray.forEach { item in
            self.headerContainer.addArrangedSubview(item)
        }
    }
    
    private func prepareSummaryView() {
        self.summaryView = SummaryView(text: book?.summary ?? "")
    }
    
    private func prepareCollection() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.register(
            DashboardCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: DashboardCollectionViewCell.self)
        )
        
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.showsHorizontalScrollIndicator = false
        
        self.collectionView?.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(Constants.itemHeight)
        }
    }
    
    private func prepareReadNowButton() {
        let button = UIButton()
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.notoSansOriyaBold(size: 16.0),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        let title = NSAttributedString(string: "Read Now", attributes: attributes)
        button.setAttributedTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lovePink
        button.layer.cornerRadius = Constants.readNowButtonHeight / 2
        
        button.addTarget(
            self,
            action: #selector(self.handleReadNow),
            for: .touchUpInside
        )
        
        self.readNowButtonView.addSubview(button)
        
        button.snp.makeConstraints {
            $0.height.equalTo(Constants.readNowButtonHeight)
            $0.top.equalTo(Constants.readNowButtonTopInset)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(Constants.readNowButtonHorizontalInsets)
        }
    }
    
    private func prepareContainer() {
        self.container.removeAllArrangedSubviews()
        
        self.container.addArrangedSubview(self.headerContainer)
        self.container.addArrangedSubview(SeparatorView())
        self.container.addArrangedSubview(self.summaryView ?? UIView())
        self.container.addArrangedSubview(SeparatorView())
        self.container.addArrangedSubview(self.collectionTitleView)
        self.container.addArrangedSubview(self.collectionView ?? UIView())
        self.container.addArrangedSubview(self.readNowButtonView)
    }
    
    @objc private func handleReadNow() {
        guard let book else { return }
        self.handler?(book)
    }
}

extension InfoBoardView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recommended?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: DashboardCollectionViewCell.self),
            for: indexPath
        ) as? DashboardCollectionViewCell,
              let recommended
        else { return UICollectionViewCell() }
        
        let model = BookCellModel.model(from: recommended[indexPath.item]) { [weak self] event in
            self?.handle(events: event)
        }
        
        cell.configure(with: model, isBlack: true)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recommended else { return }
        self.handle(events: .needShowDetails(recommended[indexPath.item]))
    }
}
