//
//  DetailInfoCell.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/28.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit

class DetailInfoCell: UITableViewCell {
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupViews(){
        for (key, value) in dataSource.enumerated() {
            print(key, value)
        }
    }
    
}

fileprivate let dataSource: [(String,String)] = [
    ("Seller", "Hangzhou NetEase Leihuo Technology Co., Ltd."),
    ("Size", "2.5GB"),
    ("Category", "Games: Strategy"),
    ("Compatibility", "Works on this iphone"),
    ("Languages", "Simplified Chinese"),
    ("Age Rating", "9+"),
    ("In-App Purchases", "Yes"),
    ("Copyright", "©1997-2019 网易公司版权所有")
]
