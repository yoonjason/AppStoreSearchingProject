//
//  RatingView.swift
//  AppStoreSearchingProject
//
//  Created by Bradley.yoon on 2021/12/01.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

public protocol RatingViewDelegate {
    func ratingView(_ ratingView: RatingView, didUpdate rating:Double)
}

extension RatingViewDelegate {
    func ratingView(_ ratingView: RatingView, didUpdate rating:Double) {
        
    }
}

@IBDesignable
open class RatingView: UIView {
    
//    open weak var delegate:RatingViewDelegate?
    
    
    
}
