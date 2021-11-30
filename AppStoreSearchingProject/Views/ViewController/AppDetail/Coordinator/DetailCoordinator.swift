//
//  AppDetailCoordinator.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit


protocol AppDetailCoordinator: AnyObject {
    func imagePreivew(_ imageUrls: [String], currentIndex: Int)
    func reviewDetail(_ entries: [Entry])
    func developer(_ compnayName: String)
}

class AppDetailCoordinatorImp: Coordinator {
    
    unowned let navigationController: UINavigationController
    var data : AppData?
    var appId : Int?
    
    init(navigationController: UINavigationController,
         data: AppData,
         appId: Int
    ) {
        self.data = data
        self.appId = appId
        self.navigationController = navigationController
    }
    
    func start() {
        guard let vc = new(name: "Detail", storyboard: "Main") as? DetailViewController else {
            return
        }
        vc.coordinator = self
        vc.data = data
        vc.appId = appId ?? 0
        navigationController.pushViewController(vc, animated: true)
    }
}

extension AppDetailCoordinatorImp: AppDetailCoordinator {
    
    func imagePreivew(_ imageUrls: [String], currentIndex: Int) {
        let coordinator = ImagePreviewCoordinatorImp(navigationController: navigationController, imageUrls: imageUrls, currentIndex: currentIndex)
        coordinate(to: coordinator)
    }
    
    func reviewDetail(_ entries: [Entry]) {
        let coordinator = ReviewDetailCoordinatorImp(navigationController: navigationController, entries: entries)
        coordinate(to: coordinator)
    }
    
    func developer(_ compnayName: String) {
        let coordinator = DeveloperCoordinatorImp(navigationController: navigationController, title: compnayName)
        coordinate(to: coordinator)
    }
}
