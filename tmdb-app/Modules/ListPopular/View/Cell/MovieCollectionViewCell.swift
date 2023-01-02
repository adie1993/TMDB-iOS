//
//  MovieCollectionViewCell.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgVw: UIImageView!
    
    static let id = "MovieCollectionViewCell"
    
    override func prepareForReuse() {
        imgVw.image = nil
        super.prepareForReuse()
    }
    
    func bind(data:Movie){
        
        if let posterPath = data.posterPath{
            guard let url = URL(string: Constant.ImageURL.mediumQuality + posterPath) else { return }
            imgVw.setImage(url: url)
        }else{
            guard let url = URL(string: Constant.ImageURL.posterPlaceholder) else { return }
            imgVw.setImage(url: url)
        }
    }

}
