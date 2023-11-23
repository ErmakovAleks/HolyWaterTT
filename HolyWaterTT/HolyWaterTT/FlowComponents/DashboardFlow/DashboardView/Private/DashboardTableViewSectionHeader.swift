//
//  DashboardTableViewSectionHeader.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 23.11.2023.
	

import UIKit
import SnapKit

fileprivate extension Constants {
    
    static let titleFontHeight = 20.0
    static let titleLeadingInset = 16.0
}

class DashboardTableViewSectionHeader: UITableViewHeaderFooterView {
    
    // MARK: -
    // MARK: Variables
    
    let title = UILabel()
    
    // MARK: -
    // MARK: Initializators

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.configureTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Functions
    
    private func configureTitle() {
        
        self.title.textColor = .white
        self.title.font = .notoSansOriyaBold(size: Constants.titleFontHeight)
        self.title.textAlignment = .left
        self.title.sizeToFit()
        
        self.contentView.addSubview(self.title)
        
        self.title.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().inset(Constants.titleLeadingInset)
        }
    }
}
