//
//  DeatilDescriptionCell.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/28.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit

class DeatilDescriptionCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var developerView: UIView!
    @IBOutlet weak var moreLabel: UILabel!
    
    var tapped: () -> Void = { }

    func setData(_ data: AppData) {
        if let group = data.sellerName {
            developerLabel.text = group
        }
        if let description = data.descriptionField {
            descriptionLabel.text = description
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(developerGesture(_:)))
        developerView.addGestureRecognizer(gesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func developerGesture(_ sender: UITapGestureRecognizer) {
        tapped()
    }
}
