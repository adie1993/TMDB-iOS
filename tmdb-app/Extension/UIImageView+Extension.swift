//
//  UIImageView+Extension.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import Kingfisher
import UIKit

extension UIImageView {
    public func setImage(url: URL) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: UIImage(named: Constant.Images.posterPlaceholder))
    }
    
    public func setDetailImage(url: URL) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: UIImage(named: Constant.Images.detailPlaceholder))
    }
    
    public func setAvatar(url: URL) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: UIImage(named: Constant.Images.personPlaceholder))
    }
}
