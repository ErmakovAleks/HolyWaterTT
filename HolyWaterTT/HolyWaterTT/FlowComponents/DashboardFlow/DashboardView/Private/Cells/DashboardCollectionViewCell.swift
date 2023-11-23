//
//  DashboardCollectionViewCell.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 22.11.2023.
	

import UIKit

fileprivate extension Constants {
    
    static let imageViewCornerRadius = 16.0
    static let imageViewHeight = 150.0
    static let titleLabelTopOffset = 4.0
    static let titleLabelHeight = 36.0
    static let titleFontSize = 15.0
}

final class DashboardCollectionViewCell: UICollectionViewCell {
    
    // MARK: -
    // MARK: Variables
    
    let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    // MARK: -
    // MARK: CollectionViewCell Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }
    
    // MARK: -
    // MARK: Internal functions
    
    func configure(with model: BookCellModel) {
        self.titleLabel.text = model.name
        model.handler(.needLoadPoster(model.coverURL, self))
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepare() {
        self.contentView.backgroundColor = .clear
        self.prepareImageView()
        self.prepareTitleLabel()
    }
    
    private func prepareImageView() {
        self.imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        self.imageView.clipsToBounds = true
        self.imageView.frame = self.contentView.bounds
        
        self.contentView.addSubview(self.imageView)
        
        self.imageView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.height.equalTo(Constants.imageViewHeight)
            $0.bottom.equalToSuperview().inset(40.0)
        }
    }
    
    private func prepareTitleLabel() {
        self.titleLabel.font = .notoSansOriya(size: Constants.titleFontSize)
        self.titleLabel.textColor = .white.withAlphaComponent(0.7)
        self.titleLabel.textAlignment = .left
        self.titleLabel.numberOfLines = 2
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.contentMode = .topLeft
        
        self.contentView.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(self.imageView.snp.bottom).offset(Constants.titleLabelTopOffset)
        }
    }
}
