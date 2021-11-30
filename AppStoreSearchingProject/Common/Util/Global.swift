//
//  Global.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

func new(name: String, storyboard: String = "") -> UIViewController {
    let storybordName = !storyboard.isEmpty ? storyboard : name
    return UIStoryboard(name: "\(storybordName)", bundle: nil).instantiateViewController(withIdentifier: name)
}

let screenHeight = UIScreen.main.bounds.size.height
let screenWidth = UIScreen.main.bounds.size.width
let screenSize = UIScreen.main.bounds.size
