//
//  DeveloperCoorninator.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/12/01.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

protocol DeveloperCoordinator: AnyObject {
    
}

class DeveloperCoordinatorImp: Coordinator {
    
    
    unowned let navigationController: UINavigationController
    var title: String?
    
    
    init(navigationController: UINavigationController,
         title: String
    ) {
        self.navigationController = navigationController
        self.title = title
    }
    
    func start() {
        //developer
        guard let vc = new(name: "Developer", storyboard: "Main") as? DeveloperViewController else {
            return
        }
        vc.coordinator = self
        vc.title = title
        vc.developer = title
        navigationController.navigationBar.topItem?.title = "뒤로"
        navigationController.pushViewController(vc, animated: true)
    }
}

extension DeveloperCoordinatorImp: DeveloperCoordinator {
    
}
