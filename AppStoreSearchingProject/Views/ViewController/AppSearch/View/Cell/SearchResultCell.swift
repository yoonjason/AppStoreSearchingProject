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
    
    var tapped : () -> Void = {}

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

    var screenShotImageViews: [UIImageView] {
        return imageStackView.arrangedSubviews as! [UIImageView]
    }

    override func prepareForReuse() {
        appImageView.image = nil
        titleLabel.text = nil
        descLabel.text = nil
        userCountingLabel.text = nil
        screenShotImageViews.forEach { imageView in
            imageView.image = nil
        }
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
            userCountingLabel.text = changeUserCount(count: userCounting) + " ( \(userCounting.toDecimalFormat!) )"
        }

        if let screenShots = appData.screenshotUrls?.enumerated() {
            for (index, screenshot) in screenShots {
                if index > 2 {
                    return
                }
                DispatchQueue.global().async {
                    guard let imageData = try? Data(contentsOf: URL(string: screenshot)!) else { return }
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.screenShotImageViews[index].image = image
                    }

                }
            }
        }

    }



    func changeUserCount(count: Int) -> String {
        var returnValue = String(count)
        if returnValue.count == 4 {
            let range = NSMakeRange(0, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range) + "천"

        } else if returnValue.count == 5 {
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(1, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range1) + "." + (NSString(string: returnValue)).substring(with: range2) + "만"
        } else if returnValue.count == 6 {
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(1, 1)
            let range3 = NSMakeRange(2, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range1) + (NSString(string: returnValue)).substring(with: range2) + "." + (NSString(string: returnValue)).substring(with: range3) + "만"
        }
        else if returnValue.count == 7 {
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(1, 1)
            let range3 = NSMakeRange(2, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range1) + (NSString(string: returnValue)).substring(with: range2) + (NSString(string: returnValue)).substring(with: range3) + "만"
        }
        return returnValue
    }

    
}
