//
//  CenterSnapCollectionViewFlowLayout.swift
//  HolyWaterTT
//
//  Created by Aleksandr Ermakov on 21.11.2023.
	

import UIKit

final class CenterSnapCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(
                forProposedContentOffset: proposedContentOffset,
                withScrollingVelocity: velocity
            )
        }
        
        let parent = super.targetContentOffset(
            forProposedContentOffset: proposedContentOffset,
            withScrollingVelocity: velocity
        )
        
        let itemWidth = itemSize.width + minimumLineSpacing
        var currentItemIndex = round(collectionView.contentOffset.x / itemWidth)
        
        if velocity.x > 0 {
            currentItemIndex += 1
        } else if velocity.x < 0 {
            currentItemIndex -= 1
        }
        
        let nearestPageOffset = currentItemIndex * itemWidth
        return CGPoint(x: nearestPageOffset, y: parent.y)
    }
}
