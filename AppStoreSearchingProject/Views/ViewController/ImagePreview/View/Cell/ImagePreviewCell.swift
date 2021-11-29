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
        
        self.imageView.roundCorners(20)
        self.imageView.clipsToBounds = true
        self.imageView.borderColor(.lightGray)
        self.imageView.borderWidth(0.84)
    }

}
