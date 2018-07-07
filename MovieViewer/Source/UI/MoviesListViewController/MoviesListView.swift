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
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var popularFilmsButton: UIButton!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureView()
    }
    
    // MARK: - Private
    private func configureView() {
        self.searchButton.setTitle(UITitles.searchButton.rawValue, for: .normal)
        self.popularFilmsButton.setTitle(UITitles.popularFilmsButton.rawValue, for: .normal)
        self.searchTextField.placeholder = UITitles.textFieldPlaceholder.rawValue
        self.collectionView.register(cellClass: MovieCollectionViewCell.self)
        self.collectionView.setCollectionViewLayout(MoviesCollectionViewFlowLayout(), animated: true)
    }
}
