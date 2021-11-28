//
//  UINib+.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/28.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

fileprivate extension UINib {

    static func nib(named nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }

    static func loadSingleView(_ nibName: String, owner: Any?) -> UIView {
        return nib(named: nibName).instantiate(withOwner: owner, options: nil)[0] as! UIView
    }
}

// MARK: App Views
public extension UINib {
    class func loadNib(_ owner: AnyObject) -> UIView {
        return loadSingleView(NSStringFromClass(owner.classForCoder).components(separatedBy: ".").last!, owner: owner)
    }
}
