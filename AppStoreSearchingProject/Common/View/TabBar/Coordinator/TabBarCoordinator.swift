//
//  TabBarCoordinator.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarCoordinator: AnyObject {
    func setViewControllers()
}


class TabBarCoordinatorImp: Coordinator {

    unowned let window: UIWindow
    private var initData: Any?

    init(window: UIWindow,
         initData: Any?) {
        self.window = window
        self.initData = initData
    }

    func start() {
        let tabBarController = TabBarController()
        tabBarController.coordinator = self
        
        self.window.rootViewController = tabBarController
        self.window.makeKeyAndVisible()
        
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {},
                          completion: { _ in })
    }

}

extension TabBarCoordinatorImp: TabBarCoordinator {

    func setViewControllers() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }

            if let tabBarController = self.window.rootViewController as? TabBarController {
                let appSearchCoordinator = AppSearchCoordinatorImp(tabBarController: tabBarController)
                self.coordinate(to: appSearchCoordinator)
            }
        }
    }
}
