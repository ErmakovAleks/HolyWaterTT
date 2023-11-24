//
//  HeadCollectionViewFlowLayout.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 23.11.2023.
	

import UIKit

final class HeadCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: -
    // MARK: Overrided functions
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        guard let collectionView = collectionView else { return proposedContentOffset }

        let targetRect = CGRect(
            x: proposedContentOffset.x, y: 0,
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )
        
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude

        guard let attributesList = super.layoutAttributesForElements(in: targetRect) else { return proposedContentOffset
        }
        
        attributesList.forEach {
            if abs($0.center.x - horizontalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = $0.center.x - horizontalCenter
            }
        }

        return CGPoint(
            x: proposedContentOffset.x + offsetAdjustment,
            y: proposedContentOffset.y
        )
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      
        guard let collectionView = collectionView,
              let attributesList = super.layoutAttributesForElements(in: rect) else { return nil }

        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)

        attributesList.forEach { attributes in
            let distance = visibleRect.midX - attributes.center.x
            let newScale = max(1 - abs(distance) * 0.001, 0.8)
            
            attributes.transform = .init(scaleX: newScale, y: newScale)
        }

        return attributesList
    }
}
