//
//  NewFeatureCell.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/28.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit

class DetailNewFeatureCell: UITableViewCell {
    
    @IBOutlet weak var versionHistoryBtn: UIButton!
    @IBOutlet weak var newFeatureLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    
    func setData(_ data: AppData) {
        if let releaseNotes = data.releaseNotes, let date = data.currentVersionReleaseDate, let version = data.version {
            updateDateLabel.updateTime(date)
            versionLabel.text = version
            descriptionLabel.text = releaseNotes
        }

    }

    override func prepareForReuse() {

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
