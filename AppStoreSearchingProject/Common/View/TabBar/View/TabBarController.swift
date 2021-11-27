//
//  TabBarController.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var coordinator: TabBarCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        moveToViewContollers()
    }
    
    func moveToViewContollers() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }

            self.coordinator.setViewControllers()
        }
    }
}
