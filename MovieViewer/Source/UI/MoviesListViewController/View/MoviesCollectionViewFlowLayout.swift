//
//  MoviesCollectionViewLayout.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/6/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import Foundation
import UIKit

class MoviesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 5
        minimumLineSpacing = 5
        scrollDirection = .vertical
        sectionHeadersPinToVisibleBounds = true
        sectionInset = UIEdgeInsetsMake(5, 5, 0, 5)
    }
    
    func itemWidth() -> CGFloat {
        let collectionView = self.collectionView ?? UICollectionView()
        
        switch UIScreen.main.traitCollection.userInterfaceIdiom {
        case .phone:
            return ((collectionView.frame.width - 15)/2)
        case .pad:
            if collectionView.frame.height > collectionView.frame.width {
                return ((collectionView.frame.width - 20)/3)
            } else {
                return ((collectionView.frame.width - 25)/4)
            }
            
        default :
            return ((collectionView.frame.width - 15)/2)
        }
    }
    
    func itemHeight() -> CGFloat {
        let collectionView = self.collectionView ?? UICollectionView()
        
        switch UIScreen.main.traitCollection.userInterfaceIdiom {
        case .phone:
            if collectionView.frame.height > collectionView.frame.width {
                return ((collectionView.frame.height)/2)
            } else {
                return collectionView.frame.height
            }
            
        case .pad:
            if collectionView.frame.height > collectionView.frame.width {
                return ((collectionView.frame.height)/3)
            } else {
                return ((collectionView.frame.height)/2)
            }
            
        default :
            return ((collectionView.frame.height)/2)
        }
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth(), height: itemHeight())
        }
        
        get {
            return CGSize(width: itemWidth(), height: itemHeight())
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let collectionView = self.collectionView ?? UICollectionView()
        
        return collectionView.contentOffset
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
    }
}
