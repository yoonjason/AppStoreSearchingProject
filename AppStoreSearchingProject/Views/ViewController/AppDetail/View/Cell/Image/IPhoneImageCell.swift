//
//  IPhoneImageCell.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/28.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit

class IPhoneImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setImage(_ imageUrl: String) {
        DispatchQueue.main.async {
            guard let imageData = try? Data(contentsOf: URL(string: imageUrl)!) else { return }
            let image = UIImage(data: imageData)
            self.imageView.image = image
            self.imageView.roundCorners(20)
            self.imageView.clipsToBounds = true
        }
    }

}
