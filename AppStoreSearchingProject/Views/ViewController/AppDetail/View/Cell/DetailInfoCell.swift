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
    
    var row: [[String:String]] = [] {
        willSet(newVal) {
            
            for item in newVal {
                let rowView = DetailRowView()
                rowView.rowTitle = item.keys.first!
                rowView.rowValue = item.values.first!
                self.stackView.addArrangedSubview(rowView)
                
                rowView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    rowView.heightAnchor.constraint(equalToConstant: 40),
                    rowView.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
                    rowView.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor)
                ])
            }
        }
    }
    
    override func prepareForReuse() {
        stackView.removeAllArrangedSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
    }
  
}
