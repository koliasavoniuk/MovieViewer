//
//  MoviesListView.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/2/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import UIKit

class MoviesListView: UIView {
    
    // MARK: - Outlets
    @IBOutlet var findTextField: UITextField!
    @IBOutlet var findButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureView()
    }
    
    // MARK: - Private
    private func configureView() {
        self.findButton.setTitle(UITitles.findButton.rawValue, for: .normal)
        self.findTextField.placeholder = UITitles.textFieldPlaceholder.rawValue
        self.collectionView.register(cellClass: MovieCollectionViewCell.self)
        self.collectionView.setCollectionViewLayout(MoviesCollectionViewFlowLayout(), animated: true)
    }
}
