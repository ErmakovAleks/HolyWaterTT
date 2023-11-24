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
    static let sectionHeaderHeight = 26.0
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.pseudoLaunchView.animateProgressBar()
        self.startBannerAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.autoScrollTimer?.invalidate()
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
        case .needLoadPoster(let url, let cell):
            self.viewModel.fetchPoster(url: url) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(systemName: "photo")
                    }
                }
            }
        case .needShowDetails(let id):
            self.autoScrollTimer?.invalidate()
            self.viewModel.showDetails(for: nil, id: id)
        }
    }
    
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
        case .needShowDetails(let book):
            self.autoScrollTimer?.invalidate()
            self.viewModel.showDetails(for: book, id: nil)
        }
    }
    
    // MARK: -
    // MARK: Overrided functons
    
    override func prepareBindings(disposeBag: DisposeBag) {
        self.viewModel.library.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.bannerCollectionView?.reloadData()
                self?.dashboardTableView?.reloadData()
                self?.startBannerAnimation()
                self?.pageControl.numberOfPages = self?.viewModel.topBannerSlides.count ?? 0
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
        self.dashboardTableView = UITableView()
        self.dashboardTableView?.delegate = self
        self.dashboardTableView?.dataSource = self
        self.dashboardTableView?.register(
            DashboardTableViewCell.self,
            forCellReuseIdentifier: String(describing: DashboardTableViewCell.self)
        )
        
        self.dashboardTableView?.register(
            DashboardTableViewSectionHeader.self,
            forHeaderFooterViewReuseIdentifier: String(describing: DashboardTableViewSectionHeader.self)
        )
        
        self.view.addSubview(self.dashboardTableView ?? UIView())
    }
    
    private func dashboardStyle() {
        self.dashboardTableView?.backgroundColor = .clear
    }
    
    private func dashboardLayout() {
        guard let bannerCollectionView else { return }
        self.dashboardTableView?.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(bannerCollectionView.snp.bottom)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item % self.viewModel.topBannerSlides.count
        self.handle(events: .needShowDetails(self.viewModel.topBannerSlides[index].bookID))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.bannerCollectionView {
            let width = scrollView.frame.width
            let index = Int((scrollView.contentOffset.x + width / 2) / width)
            self.pageControl.currentPage = index % self.viewModel.topBannerSlides.count
        }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.orderedLibrary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DashboardTableViewCell.self),
            for: indexPath
        ) as? DashboardTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: self.viewModel.orderedLibrary[indexPath.section].1) { [weak self] events in
            self?.handle(events: events)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: DashboardTableViewSectionHeader.self)
        ) as? DashboardTableViewSectionHeader else { return UIView() }
        
        view.title.text = self.viewModel.orderedLibrary[section].0.rawValue

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.sectionHeaderHeight
    }
}
