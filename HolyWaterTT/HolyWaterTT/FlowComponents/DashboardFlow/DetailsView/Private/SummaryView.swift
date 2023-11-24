//
//  SummaryView.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 24.11.2023.
	

import UIKit
import SnapKit

fileprivate extension Constants {
    
    static let titleLabelLeadingInset = 16.0
    static let titleLabelTopInset = 6.0
    static let textViewHorizontalInsets = 16.0
    static let textViewVerticalInsets = 0.0
    static let textViewTopOffset = 8.0
}

final class SummaryView: UIView {
    
    // MARK: -
    // MARK: Variables
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Summary"
        label.font = UIFont.notoSansOriyaBold(size: 20.0)
        label.textColor = .almostBlack
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.notoSansOriya(size: 14.0)
        textView.textColor = .textBlack
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.sizeToFit()
        textView.isSelectable = false
        textView.textContainerInset = .init(
            top: Constants.textViewVerticalInsets,
            left: Constants.textViewHorizontalInsets,
            bottom: Constants.textViewVerticalInsets,
            right: Constants.textViewHorizontalInsets
        )
        
        return textView
    }()
    
    // MARK: -
    // MARK: Initialization
    
    init(text: String) {
        super.init(frame: .zero)
        
        self.textView.text = text
        self.prepare()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func prepare() {
        self.backgroundColor = .clear
        self.textView.backgroundColor = .clear
        self.addSubview(self.titleLabel)
        self.addSubview(self.textView)
    }
    
    private func layout() {
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.titleLabelTopInset)
            $0.leading.equalToSuperview().inset(Constants.titleLabelLeadingInset)
        }
        
        self.textView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(Constants.textViewTopOffset)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
