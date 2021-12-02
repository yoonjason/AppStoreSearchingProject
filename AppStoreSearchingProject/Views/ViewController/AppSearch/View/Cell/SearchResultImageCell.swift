//
//  SearchResultImageCell.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/30.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit

class SearchResultImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
    
    func setImage(_ imageUrl: String) {
        self.imageView.setImage(imageUrl)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        self.layoutIfNeeded()
    }
}
