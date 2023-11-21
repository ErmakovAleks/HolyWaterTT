//
//  LaunchView.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 20.11.2023.
	

import UIKit
import SnapKit

fileprivate extension Constants {
    
    static let containerSpacing = 12.0
    static let titleFontSize = 52.0
    static let subTitleFontSize = 24.0
    static let progressBarHeight = 6.0
    static let progressBarInset = 50.0
    static let progressBarCornerRadius = progressBarHeight / 2
    static let progressBarContainerHeight = 32.0
}

final class LaunchView: UIView {
    
    // MARK: -
    // MARK: Variables
    
    private var executionTime: Double
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Constants.containerSpacing
        
        return stackView
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "Book App"
        label.font = UIFont.georgiaBoldItalic(size: Constants.titleFontSize)
        label.textColor = UIColor.lovePink
        label.textAlignment = .center
        
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Book App"
        label.font = UIFont.notoSansOriyaBold(size: 24.0)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .center
        
        return label
    }()
    
    private let progressBarContainerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.2)
        view.layer.cornerRadius = Constants.progressBarCornerRadius
        
        return view
    }()
    
    private let progressIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.progressBarCornerRadius
        
        return view
    }()
    
    // MARK: -
    // MARK: Initialization
    
    init(executionTime: Double) {
        self.executionTime = executionTime
        
        super.init(frame: .zero)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Internal functions
    
    func animateProgressBar() {
        UIView.animate(withDuration: self.executionTime) {
            self.progressIndicator.snp.remakeConstraints {
                $0.leading.verticalEdges.equalToSuperview()
                $0.width.equalToSuperview()
            }
            
            self.layoutIfNeeded()
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func commonInit() {
        self.prepareBackground()
        self.prepareComponents()
    }
    
    private func prepareBackground() {
        let backgroundImageView = UIImageView(frame: self.bounds)
        backgroundImageView.image = UIImage(named: "launch")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(backgroundImageView)
        self.sendSubviewToBack(backgroundImageView)
    }
    
    private func prepareComponents() {
        self.setupComponents()
        self.layoutComponents()
    }
    
    private func setupComponents() {
        self.progressBar.addSubview(self.progressIndicator)
        self.progressBarContainerView.addSubview(self.progressBar)
        self.container.addArrangedSubview(self.title)
        self.container.addArrangedSubview(self.subTitle)
        self.container.addArrangedSubview(self.progressBarContainerView)
        
        self.addSubview(self.container)
    }
    
    private func layoutComponents() {
        self.container.snp.makeConstraints {
            $0.horizontalEdges.centerY.equalToSuperview()
        }
        
        self.progressBarContainerView.snp.makeConstraints {
            $0.height.equalTo(Constants.progressBarContainerHeight)
            $0.horizontalEdges.equalToSuperview()
        }
        
        self.progressBar.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.progressBarInset)
            $0.trailing.equalToSuperview().inset(Constants.progressBarInset)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Constants.progressBarHeight)
        }
        
        self.progressIndicator.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview()
            $0.width.equalTo(Constants.progressBarHeight)
        }
    }
}
