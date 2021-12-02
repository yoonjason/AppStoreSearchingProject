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

    func setView(data: AppData) {
        if let imageUrl = data.artworkUrl512 {
            appImageView.setImage(imageUrl)
        }
        
        if let title = data.trackName, let subTitle = data.artistName {
            titleLabel.text = title
            subTitleLabel.text = subTitle
        }
        
        if let rating = data.averageUserRating {
            rateView.rating = rating
            averageCountLabel.text = "\(round(rating * 10) / 10)"
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
    
    override func prepareForReuse() {
        appImageView.image = nil
        titleLabel.text = nil
        subTitleLabel.text = nil
        averageCountLabel.text = nil
        ageLabel.text = nil
        genreLabel.text = nil
        userReviewCountLabel.text = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
