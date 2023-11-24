//
//  SeparatorView.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 24.11.2023.
	

import UIKit
import SnapKit

fileprivate extension Constants {
    
    static let separatorHeight = 1.0
    static let separatorHorizontalInsets = 16.0
    static let separatorVerticalInsets = 0.0
}

final class SeparatorView: UIView {
    
    // MARK: -
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        self.prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepare() {
        let view = UIView()
        view.backgroundColor = .disabledGrey
        
        self.addSubview(view)

        view.snp.makeConstraints {
            $0.height.equalTo(Constants.separatorHeight)
            $0.edges.equalToSuperview().inset(
                UIEdgeInsets(
                    top: Constants.separatorVerticalInsets,
                    left: Constants.separatorHorizontalInsets,
                    bottom: Constants.separatorVerticalInsets,
                    right: Constants.separatorHorizontalInsets
                )
            )
        }
    }
}
