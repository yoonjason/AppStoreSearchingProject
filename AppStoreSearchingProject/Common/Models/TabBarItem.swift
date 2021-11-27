//
//  TabBarItem.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

enum TabBarItem: String, CaseIterable {
    case search
    
    var item: UITabBarItem {
        switch self {
        case .search:
            let image = UIImage(systemName: "magnifyingglass")
            return UITabBarItem(title: "검색", image: image, tag: 0)
        }
    }

    var tabNo: Int {
        switch self {
        case .search:
            return 0
        }
    }
}
