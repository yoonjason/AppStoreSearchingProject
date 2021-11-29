//
//  ReviewDetailCell.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/29.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit
import Cosmos

class ReviewDetailCell: UICollectionViewCell {

    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.roundBorderColor()
        bgView.roundCorners()
        bgView.borderWidth(1)
        bgView.backgroundColor = UIColor.whiteGray
    }
    
    func setData(_ entry: Entry) {
        if let content = entry.content?.label,
           let title = entry.title?.label,
           let nickname = entry.author?.name.label
        {
            contentLabel.text = content
            titleLabel.text = title
            nicknameLabel.text = nickname
            ratingView.rating = Double(entry.rating?.label ?? "") ?? 0.0
        }
    }

}
