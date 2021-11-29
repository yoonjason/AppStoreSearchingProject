//
//  ImagePreviewCoordinator.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

protocol ImagePreviewCoordinator: AnyObject {
    func dismiss()
}

class ImagePreviewCoordinatorImp: Coordinator {

    unowned let navigationController: UINavigationController
    var imageUrls: [String]?
    var currentIndex: Int?

    init(navigationController: UINavigationController,
        imageUrls: [String],
        currentIndex: Int
    ) {
        self.currentIndex = currentIndex
        self.imageUrls = imageUrls
        self.navigationController = navigationController
    }

    func start() {
        guard let vc = new(name: "ImagePreview", storyboard: "Main") as? ImagePreviewViewController else {
            return
        }
        vc.coordinator = self
        vc.imageUrls = imageUrls
        vc.currentImageIndex = currentIndex ?? -1
        navigationController.present(vc, animated: true, completion: nil)
    }

}

extension ImagePreviewCoordinatorImp: ImagePreviewCoordinator {
    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
