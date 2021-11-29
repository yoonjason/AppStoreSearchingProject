//
//  UIColor+.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/29.
//  Copyright © 2021 yoon. All rights reserved.
//
import UIKit

extension UIColor {
 
    static let whiteGray      = UIColor(named: "whitegray")
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
}
