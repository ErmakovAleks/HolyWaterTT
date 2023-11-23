//
//  BannerCollectionViewCell.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 21.11.2023.
	

import UIKit
import SnapKit

fileprivate extension Constants {
    
    static let imageViewCornerRadius = 16.0
}

final class BannerCollectionViewCell: UICollectionViewCell {
    
    // MARK: -
    // MARK: Variables
    
    let imageView = UIImageView()
    
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
    
    func configure(with model: TopBannerSlideCellModel) {
        model.handler(.needLoadPoster(model.cover, self))
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepare() {
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.imageView)
        self.imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        self.imageView.clipsToBounds = true
        self.imageView.frame = self.contentView.bounds
    }
}
