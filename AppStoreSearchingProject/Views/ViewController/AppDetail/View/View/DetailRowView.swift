//
//  DetailRowView.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/28.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit

class DetailRowView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    var rowTitle: String = "" {
        willSet(newVal) {
            self.titleLabel.text = newVal
        }
    }
    
    var rowValue: String = "" {
        willSet(newVal) {
            let attributedString = NSMutableAttributedString(string: newVal)
            self.valueLabel.attributedText = attributedString
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {

        let view = UINib.loadNib(self)
        view.frame = self.bounds
        self.addSubview(view)
    }

}
