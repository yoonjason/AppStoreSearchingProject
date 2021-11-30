//
//  ImagePreviewCell.swift
//  AppStoreSearchingProject
//
//  Created by Bradley.yoon on 2021/11/29.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit

class ImagePreviewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
    
    func setImage(_ imageUrl: String) {
        imageView.setImage(imageUrl)
    }

}
