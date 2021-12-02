//
//  UIImageView+.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/30.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func setImage(_ imageString: String) {
        
        Task {
            do {
                let image = try await NetworkManager.shared.fetchImage(with: imageString)
                self.image = image
                self.roundCorners(20)
                self.roundBorderColor()
                self.borderWidth(0.84)
            } catch {

            }
        }
    }
}
