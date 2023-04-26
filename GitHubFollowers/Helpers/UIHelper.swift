//
//  UIHelper.swift
//  GitHubFollowers
//
//  Created by Oliwia Procyk on 17/04/2023.
//

import UIKit

enum UIHelper {
    
    static func createThreeColumnFlowLayout(with view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        let itemHeight = itemWidth + 40

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        return flowLayout
    }
}
