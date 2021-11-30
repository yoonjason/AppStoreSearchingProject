//
//  ReviewDetailCoordinator.swift
//  AppStoreSearchingProject
//
//  Created by Bradley.yoon on 2021/11/30.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

protocol ReviewDetailCoordinator: AnyObject {

}

class ReviewDetailCoordinatorImp: Coordinator {



    unowned let navigationController: UINavigationController
    var entries: [Entry]?

    init(navigationController: UINavigationController,
         entries: [Entry]
    ){
        self.navigationController = navigationController
        self.entries = entries
    }

    //ReviewDetail
    func start() {
        guard let vc = new(name: "ReviewDetail", storyboard: "Main") as? ReviewDetailViewController else {
            return
        }
        vc.coordinator = self
        vc.entries = entries
        vc.title = "평가 및 리뷰"
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always
        navigationController.pushViewController(vc, animated: true)
    }
}

extension ReviewDetailCoordinatorImp: ReviewDetailCoordinator {

}
