//
//  Extensions.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/08.
//  Copyright © 2020 yoon. All rights reserved.
//

import Foundation
import UIKit









struct screen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let widthRatio = UIScreen.main.bounds.size.width / 320
    static let heightRatio = (UIScreen.main.bounds.size.height == 480) ?1 :(UIScreen.main.bounds.size.height / 568)
    static let maxLength = max(screen.width, screen.height)
    static let minLength = min(screen.width, screen.height)
}
