//
//  DashboardView.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import UIKit
import SnapKit
import RxSwift

fileprivate extension Constants {
    
    static let animationInterval = 2.0
    static let bannerTimeInterval = 3.0
    
    static let headerFontSize = 20.0
    static let headerHeight = 48.0
    static let headerTitleLeadingInset = 16.0
    static let headerTitleBottomInset = 8.0
    
    static let bannerDimensionsRatio = 343.0/200.0
    static let bannerMinimumInteritemSpacing: CGFloat = 0.0
    static let bannerMinimumLineSpacing: CGFloat = 16.0
    static let bannerSectionInset = 16.0
    static let bannerItemHorizontalInset = 16.0
    static let bannerItemVerticalInset = 20.0
    
    static let pageControlBottomInset = 20.0
}

final class DashboardView: BaseView<DashboardViewModel, DashboardOutputEvents> {
    
    // MARK: -
    // MARK: Variables
    
    private let pseudoLaunchView = LaunchView(executionTime: Constants.animationInterval)
    private let header = UIView()
    private let pageControl = UIPageControl()
    
    private var bannerCollectionView: UICollectionView?
    private var dashboardTableView: UITableView?
    private var autoScrollTimer: Timer?
    
    // MARK: -
    // MARK: ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .deepGrey
        
        self.pseudoLaunchView.frame = self.view.bounds
        self.view.addSubview(self.pseudoLaunchView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.pseudoLaunchView.animateProgressBar()
        self.startBannerAnimation()
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func startBannerAnimation() {
        guard self.viewModel.topBannerSlides.count != 0 else { return }
        self.scrollToMiddle(atIndex: 0)
        self.autoScrollTimer = Timer.scheduledTimer(
            timeInterval: Constants.bannerTimeInterval,
            target: self,
            selector: #selector(scrollToNextItem),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func handle(events: TopBannerSlideCellModelOutputEvents) {
        switch events {
        case .needLoadPoster(let url, let imageView):
            self.viewModel.fetchPoster(url: url) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        imageView?.image = image
                    }
                case .failure(_):
                    imageView?.image = UIImage(systemName: "photo")
                }
            }
        }
    }
    
    // MARK: -
    // MARK: Overrided functons
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.viewModel.library.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.bannerCollectionView?.reloadData()
                self?.startBannerAnimation()
            }
        }
        .disposed(by: disposeBag)
    }
    
    override func setup() {
        self.headerSetup()
        self.bannerSetup()
        self.pageControlSetup()
        self.dashboardSetup()
    }
    
    override func style() {
        self.bannerStyle()
        self.pageControlStyle()
        self.dashboardStyle()
    }
    
    override func layout() {
        self.bannerLayout()
        self.pageControlLayout()
        self.dashboardLayout()
    }
    
    // MARK: -
    // MARK: Prepare Header
    
    private func headerSetup() {
        let label = UILabel()
        label.text = "Library"
        label.font = UIFont.notoSansOriyaBold(size: Constants.headerFontSize)
        label.textColor = UIColor.lovePink
        label.textAlignment = .left
        label.sizeToFit()
        
        self.header.addSubview(label)
        self.view.addSubview(self.header)
        
        header.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(Constants.headerHeight)
        }
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.headerTitleLeadingInset)
            $0.bottom.equalToSuperview().inset(Constants.headerTitleBottomInset)
        }
    }
    
    // MARK: -
    // MARK: Prepare Banner
    
    private func bannerSetup() {
        let layout = CenterSnapCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Constants.bannerMinimumInteritemSpacing
        layout.minimumLineSpacing = Constants.bannerMinimumLineSpacing
        layout.sectionInset = UIEdgeInsets(
            top: 0.0,
            left: Constants.bannerSectionInset,
            bottom: 0.0,
            right: Constants.bannerSectionInset
        )
        
        layout.itemSize = CGSize(
            width: self.view.bounds.width - 2 * Constants.bannerItemHorizontalInset,
            height: self.view.bounds.width / Constants.bannerDimensionsRatio - 2 * Constants.bannerItemVerticalInset
        )

        self.bannerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.bannerCollectionView?.decelerationRate = .fast
        self.bannerCollectionView?.delegate = self
        self.bannerCollectionView?.dataSource = self
        self.bannerCollectionView?.register(
            BannerCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: BannerCollectionViewCell.self)
        )
        
        self.view.addSubview(self.bannerCollectionView ?? UICollectionView())
    }
    
    private func bannerStyle() {
        self.bannerCollectionView?.backgroundColor = .clear
        self.bannerCollectionView?.showsHorizontalScrollIndicator = false
    }
    
    private func bannerLayout() {
        self.bannerCollectionView?.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(self.header.snp.bottom)
            $0.height.equalTo(self.view.snp.width).dividedBy(Constants.bannerDimensionsRatio)
        }
    }
    
    // MARK: -
    // MARK: Prepare PageControl
    
    private func pageControlSetup() {
        self.view.addSubview(self.pageControl)
    }
    
    private func pageControlStyle() {
        self.pageControl.numberOfPages = self.viewModel.topBannerSlides.count
        self.pageControl.currentPage = 0
        self.pageControl.currentPageIndicatorTintColor = .lovePink
        self.pageControl.pageIndicatorTintColor = .inactiveGrey
    }
    
    private func pageControlLayout() {
        self.pageControl.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.bannerCollectionView!.snp.bottom).inset(Constants.pageControlBottomInset)
        }
    }
    
    // MARK: -
    // MARK: Prepare Dashboard
    
    private func dashboardSetup() {
        
    }
    
    private func dashboardStyle() {
        
    }
    
    private func dashboardLayout() {
        
    }
}

extension DashboardView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var multiplier: Int {
        return 50
    }
    
    private var infiniteItemsCount: Int {
        return self.multiplier * self.viewModel.topBannerSlides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.infiniteItemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: BannerCollectionViewCell.self),
            for: indexPath
        ) as? BannerCollectionViewCell else { return UICollectionViewCell() }
        
        let bannersCount = self.viewModel.topBannerSlides.count
        if bannersCount != 0 {
            let model = TopBannerSlideCellModel(
                id: self.viewModel.topBannerSlides[indexPath.item % bannersCount].id,
                bookID: self.viewModel.topBannerSlides[indexPath.item % bannersCount].bookID,
                cover: self.viewModel.topBannerSlides[indexPath.item % bannersCount].cover
            ) { [weak self] event in
                self?.handle(events: event)
            }
            
            cell.configure(with: model)
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let index = Int((scrollView.contentOffset.x + width / 2) / width)
        self.pageControl.currentPage = index % self.viewModel.topBannerSlides.count
    }
    
    private func scrollToMiddle(atIndex: Int, animated: Bool = true) {
        let middleIndex = atIndex + self.multiplier * self.viewModel.topBannerSlides.count / 2
        self.bannerCollectionView?.scrollToItem(at: IndexPath(item: middleIndex, section: 0), at: .centeredHorizontally, animated: animated)
    }
    
    @objc private func scrollToNextItem() {
        guard let banner  = self.bannerCollectionView else { return }
        for cell in banner.visibleCells {
            let indexPath = banner.indexPath(for: cell)
            let nextIndexPath = (indexPath?.row ?? 0) < self.infiniteItemsCount - 1
                ? IndexPath.init(row: (indexPath?.row ?? 0) + 1, section: 0)
                : IndexPath.init(row: 0, section: 0)
            
            banner.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension DashboardView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DashboardTableViewCell.self),
            for: indexPath
        )
        
        return cell
    }
    
    
}
