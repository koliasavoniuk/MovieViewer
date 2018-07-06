//
//  MovieCollectionViewCell.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/6/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet var filmNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fill(with model: Movie) {
        self.filmNameLabel.text = model.title
    }
}
