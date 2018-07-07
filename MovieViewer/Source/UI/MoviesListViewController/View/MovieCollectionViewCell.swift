//
//  MovieCollectionViewCell.swift
//  MovieViewer
//
//  Created by Mykola Savoniuk on 7/6/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet var filmNameLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fill(with model: Movie) {
        let posterURL = URL(string: Endpoint.posterPath.rawValue + model.posterPath) ?? URL(fileURLWithPath: "")
        self.filmNameLabel.text = model.title
        self.posterImageView.sd_setImage(with: posterURL,
                                         placeholderImage: nil,
                                         options: .highPriority,
                                         progress: nil,
                                         completed: nil)
    }
}
