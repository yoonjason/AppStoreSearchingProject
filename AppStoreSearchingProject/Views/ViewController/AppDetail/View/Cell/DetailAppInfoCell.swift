//
//  DetailInfoCell.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/28.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit
import Cosmos

class DetailAppInfoCell: UITableViewCell {
    
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var averageCountLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var userReviewCountLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var chartLabel: UILabel!
    @IBOutlet weak var downloadTopConstant: NSLayoutConstraint!

    func setView(data: AppData) {
        //artworkUrl100
        let url = URL(string: data.artworkUrl512!)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.appImageView.image = UIImage(data: data!)
            }
        }
        if let title = data.trackName, let subTitle = data.artistName {
            titleLabel.text = title
            subTitleLabel.text = subTitle
            let width = (data.trackName! as NSString).size(withAttributes: [NSAttributedString.Key.font: titleLabel.font]).width
            if width > 230 {
//                downloadTopConstant.constant = 0
            }


        }
        if let rating = data.averageUserRating {
            rateView.rating = rating
            averageCountLabel.text = "\(round(rating))"
        }


        if let age = data.trackContentRating {
            ageLabel.text = age
        }
        if let genres = data.genres {
            genreLabel.text = genres[0]
        }
        if let userCounting = data.userRatingCountForCurrentVersion {
            userReviewCountLabel.changeUserCount(count: userCounting, detail: true)
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
