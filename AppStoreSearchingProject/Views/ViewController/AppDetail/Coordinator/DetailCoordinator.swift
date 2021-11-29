//
//  AppDetailCoordinator.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit


protocol DetailCoordinator: AnyObject {
    func imagePreivew(_ imageUrls: [String], currentIndex: Int)
}

class DetailCoordinatorImp: Coordinator {
    
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

extension DetailCoordinatorImp: DetailCoordinator {
    
    func imagePreivew(_ imageUrls: [String], currentIndex: Int) {
        let coordinator = ImagePreviewCoordinatorImp(navigationController: navigationController, imageUrls: imageUrls, currentIndex: currentIndex)
        coordinate(to: coordinator)
    }
    
    
}
