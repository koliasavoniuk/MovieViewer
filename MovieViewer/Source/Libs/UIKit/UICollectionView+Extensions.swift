//
//  UICollectionView+Extensions.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/6/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    /**
     Create UINib object based on cells type and register nib with cell type as identifier
     */
    func register(cells: Set<String>) {
        cells.forEach { type in
            self.register(cell: type)
        }
    }
    
    func register(cell: String) {
        let nib = UINib(nibName: cell, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: cell)
    }
    
    func register(cellClass: AnyClass) {
        self.register(cell: toString(cellClass))
    }
    
    func register(supplementaryView: String, ofKind kind: String) {
        let nib = UINib(nibName: supplementaryView, bundle: nil)
        self.register(nib,
                      forSupplementaryViewOfKind: kind,
                      withReuseIdentifier: supplementaryView)
    }
    
    func register(supplementaryViewClass: UICollectionReusableView.Type, ofKind kind: String) {
        self.register(supplementaryView: "\(supplementaryViewClass)",
            ofKind: kind)
    }
}
