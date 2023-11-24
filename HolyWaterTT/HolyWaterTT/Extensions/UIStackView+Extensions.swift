//
//  UIStackView+Extensions.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 24.11.2023.
	

import UIKit

extension UIStackView {
    
    public func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { result, subview -> [UIView] in
            self.removeArrangedSubview(subview)
            
            return result + [subview]
        }
        
        //NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach{
            $0.removeFromSuperview()
        }
    }
}
