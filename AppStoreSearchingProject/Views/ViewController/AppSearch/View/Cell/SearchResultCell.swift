//
//  SearchResultCell.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit
import Cosmos

class SearchResultCell: UITableViewCell {

    var tapped: () -> Void = { }

    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var userCountingLabel: UILabel!
    @IBOutlet weak var getBtn: UIButton!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBAction func onActionGet(_ sender: Any) {
        tapped()
    }

    override func prepareForReuse() {
        appImageView.image = nil
        titleLabel.text = nil
        descLabel.text = nil
        userCountingLabel.text = nil
        imageStackView.removeAllArrangedSubviews()
    }

    func setData(appData: AppData) {

        let url = URL(string: appData.artworkUrl60!)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.appImageView.image = UIImage(data: data!)
            }
        }
        if let title = appData.trackName {
            titleLabel.text = title
        }

        if let genres = appData.genres {
            descLabel.text = genres[0]
        }
        if let rating = appData.averageUserRating {
            rateView.rating = rating
        }
        if let userCounting = appData.userRatingCountForCurrentVersion {
            userCountingLabel.changeUserCount(count: userCounting, detail: false)
        }

        if let screenShots = appData.screenshotUrls?.enumerated() {
            if let gerneName = appData.primaryGenreName, gerneName == "Games" {
                let imageView = UIImageView()
                imageView.roundCorners(20)
                imageView.roundBorderColor()
                imageView.borderWidth(0.84)
                imageStackView.addArrangedSubview(imageView)
                guard let singleImage = appData.screenshotUrls?[0] else { return }
                guard let imageData = try? Data(contentsOf: URL(string: singleImage)!) else { return }
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: imageData)
                }
            } else {
                for (index, screenshot) in screenShots {
                    if index > 2 {
                        return
                    }
                    let imageView = UIImageView()
                    imageStackView.addArrangedSubview(imageView)
                    imageView.roundCorners(20)
                    imageView.roundBorderColor()
                    imageView.borderWidth(0.84)
                    DispatchQueue.global().async {
                        guard let imageData = try? Data(contentsOf: URL(string: screenshot)!) else { return }
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            imageView.image = image
                        }

                    }
                }
            }
        }

    }

}
