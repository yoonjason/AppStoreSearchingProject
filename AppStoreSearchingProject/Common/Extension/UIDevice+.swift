//
//  UIDevice+.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

public extension UIDevice {
  
  var safeAreaTopHeight: CGFloat {
    return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0
  }

  var safeAreaBottomHeight: CGFloat {
    return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.bottom ?? 0
  }
}

