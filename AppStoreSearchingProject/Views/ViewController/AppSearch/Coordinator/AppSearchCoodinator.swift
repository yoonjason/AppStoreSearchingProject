//
//  AppSearchCoodinator.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

protocol AppSearchCoordinator: AnyObject {

}

class AppSearchCoordinatorImp: Coordinator {

    unowned let tabBarController: TabBarController
    let navigationController = UINavigationController()

    init(tabBarController: TabBarController) {
        if tabBarController.viewControllers == nil {
            tabBarController.setViewControllers([navigationController], animated: false)
        }
        else {
            tabBarController.viewControllers?.append(navigationController)
        }

        self.tabBarController = tabBarController
        
    }

    func start() {
        guard let vc = new(name: "AppSearch", storyboard: "Main") as? AppSearchViewController else {
            return
        }
        vc.coodinator = self
        navigationController.pushViewController(vc, animated: false)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem = TabBarItem.search.item
    }


    func setTabBar() -> UITabBarController {
        let tabBarController = UITabBarController()

        let firstItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        let firstViewCoordinator = AppSearchViewController()
        firstViewCoordinator.coodinator = self
        firstViewCoordinator.tabBarItem = firstItem

        tabBarController.viewControllers = [firstViewCoordinator]

        return tabBarController
    }
}

extension AppSearchCoordinatorImp: AppSearchCoordinator {

}

