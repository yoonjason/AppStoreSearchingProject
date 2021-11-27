//
//  UITableViewCell+.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

public extension UITableViewCell {
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                let newSuperview = table?.superview
                table = newSuperview
            }
            return table as? UITableView
        }
    }

    // Reuse Identifier String
    class var reuseIdentifier: String {
        return "\(self.self)"
    }

    // Registers the Nib with the provided table
    static func registerWithTable(_ table: UITableView) {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: self.reuseIdentifier, bundle: bundle)
        table.register(nib, forCellReuseIdentifier: "\(self.reuseIdentifier)")
    }
}

extension UITableViewCell {

    var reorderControlImageView: UIImageView? {
        let reorderControl = self.subviews.first { view -> Bool in
            view.classForCoder.description() == "UITableViewCellReorderControl"
        }
        return reorderControl?.subviews.first { view -> Bool in
            view is UIImageView
        } as? UIImageView
    }
}

public extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

public extension UITableViewHeaderFooterView {
    static var identifier: String{
        return String(describing: self)
    }
}
