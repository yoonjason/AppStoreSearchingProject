//
//  Extensions.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/08.
//  Copyright © 2020 yoon. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
          get {
              return layer.cornerRadius
          }
          set {
              layer.cornerRadius = newValue
              layer.masksToBounds = newValue > 0
          }
      }
  @IBInspectable
    var borderWidth: CGFloat {
      get {
        return layer.borderWidth
      }
      set {
        layer.borderWidth = newValue
      }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
      get {
        if let color = layer.borderColor {
          return UIColor(cgColor: color)
        }
        return nil
      }
      set {
        if let color = newValue {
          layer.borderColor = color.cgColor
        } else {
          layer.borderColor = nil
        }
      }
    }
}

extension Int {
  var toDecimalFormat: String? {
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = NumberFormatter.Style.decimal
      numberFormatter.locale = .current
      let formattedNumber = numberFormatter.string(from: NSNumber(value: self))
      return formattedNumber
  }
}

extension NSMutableAttributedString {
    
    public func setBold(text: String) {
        let foundRange = mutableString.range(of: text)
        if foundRange.location != NSNotFound {
            addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: UIColor.black,
                range: foundRange
            )
        }
    }
}
extension UITableView {

    func reloadOnMainThread() {
        print("reloadOnMainThread")
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}

extension String {

    func hasCaseInsensitivePrefix(_ s: String) -> Bool {
//        print("prefix === ", s)
        return prefix(s.count).caseInsensitiveCompare(s) == .orderedSame
    }
}
