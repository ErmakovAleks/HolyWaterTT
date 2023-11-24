//
//  InfoBoardHeaderItemView.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 24.11.2023.
	

import UIKit
import SnapKit

fileprivate extension Constants {
    
    static let horizontalContainerSpacing = 2.0
    static let verticalContainerSpacing = 0.0
    static let imageViewSize = 20.0
    
    static let titleFontSize = 18.0
    static let typeFontSize = 12.0
}

enum HeaderItemType: String {
    
    case readers = "Readers"
    case likes = "Likes"
    case quotes = "Quotes"
    case genre = "Genre"
}

final class InfoBoardHeaderItemView: UIView {
    
    // MARK: -
    // MARK: Variables
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoSansOriya(size: Constants.titleFontSize)
        label.textColor = .almostBlack
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoSansOriya(size: Constants.typeFontSize)
        label.textColor = .disabledGrey
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    private let imageView = UIImageView()
    
    private let horizontalContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Constants.horizontalContainerSpacing
        
        return stackView
    }()
    
    private let verticalContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Constants.verticalContainerSpacing
        
        return stackView
    }()
    
    // MARK: -
    // MARK: Initialization
    
    init(title: String, type: HeaderItemType, image: UIImage? = nil) {
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        self.typeLabel.text = type.rawValue
        self.imageView.image = image
        
        self.prepare()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepare() {
        self.horizontalContainer.addArrangedSubview(self.titleLabel)
        if imageView.image != nil {
            self.horizontalContainer.addArrangedSubview(self.imageView)
        }
        
        self.verticalContainer.addArrangedSubview(self.horizontalContainer)
        self.verticalContainer.addArrangedSubview(self.typeLabel)
        
        self.addSubview(self.verticalContainer)
    }
    
    private func layout() {
        self.verticalContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.imageView.snp.makeConstraints {
            $0.size.equalTo(Constants.imageViewSize)
        }
    }
}
