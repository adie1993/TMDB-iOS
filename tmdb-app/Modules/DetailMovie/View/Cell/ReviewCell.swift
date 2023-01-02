//
//  ReviewCell.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var reviewLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgAva: UIImageView!

    static let id = "ReviewCell"
    
    override func layoutSubviews() {
        imgAva.layer.cornerRadius = imgAva.bounds.size.width / 2
    }
    
    func bind(data: Reviews){
        
        nameLbl.text = data.author
        dateLbl.text = getStringDate(date: data.createdAt)
        reviewLbl.text = data.content
        if let avatarUrl = data.authorDetails?.avatarPath{
            if avatarUrl.contains("https"){
                guard let url = URL(string: String(avatarUrl.dropFirst())) else { return }
                imgAva.setAvatar(url: url)
            }else{
                guard let url = URL(string: Constant.ImageURL.lowQuality + avatarUrl) else { return }
                imgAva.setAvatar(url: url)
            }
            
        }else{
            imgAva.image = UIImage(named: Constant.Images.personPlaceholder)
        }
        
    }

    
}
extension ReviewCell{
    func getStringDate(date: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = formatter.date(from: date) else {
            return nil
        }
        formatter.dateFormat = "d MMMM yyyy"
        let yearOfRelease = formatter.string(from: date)

        return yearOfRelease
    }
}
