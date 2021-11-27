//
//  RecentSearchWordCell.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit

class SearchWordCell: UITableViewCell {

    @IBOutlet weak var suggestLabel: UILabel!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var recentLabel: UILabel!

    var isSuggestEnabled: Bool = false {
        didSet {
            setupViews()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    func setData(_ title: String) {
        recentLabel.text = title
    }

    func setupViews() {
        if isSuggestEnabled {
            recentLabel.isHidden = true
            searchImage.isHidden = false
            suggestLabel.isHidden = false
        } else {
            recentLabel.isHidden = false
            searchImage.isHidden = true
            suggestLabel.isHidden = true
        }
    }


    func set(term: String, searchedTerm: String) {
        let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 21),
                .foregroundColor: UIColor(white: 0.56, alpha: 1.0)
        ]
        let attributedString = NSAttributedString(
            string: term.lowercased(),
            attributes: attributes
        )
        let mutableAttributedString = NSMutableAttributedString(
            attributedString: attributedString
        )
        mutableAttributedString.setBold(text: searchedTerm.lowercased())
        suggestLabel.attributedText = mutableAttributedString
    }

}
