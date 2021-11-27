//
//  AppCoordinator.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let splashCoordinator = SplashCoordinatorImp(window: window)
        coordinate(to: splashCoordinator)
    }
    
}
