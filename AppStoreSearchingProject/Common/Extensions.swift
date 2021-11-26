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


    func changeUserCount(count : Int) -> String {
        var returnValue = String(count)
        if returnValue.count == 4 {
            let range = NSMakeRange(0, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range) + "천"

        }else if returnValue.count == 5 {
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(1, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range1) + "." + (NSString(string: returnValue)).substring(with: range2) + "만"
        }else if returnValue.count == 6 {
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(1, 1)
            let range3 = NSMakeRange(2, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range1) + (NSString(string: returnValue)).substring(with: range2) + "." + (NSString(string: returnValue)).substring(with: range3) + "만"
        }
        else if returnValue.count == 7 {
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(1, 1)
            let range3 = NSMakeRange(2, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range1) + (NSString(string: returnValue)).substring(with: range2) + (NSString(string: returnValue)).substring(with: range3) + "만"
        }
        return returnValue
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


extension Date {
    init(dateString:String) {
        self = Date.iso8601Formatter.date(from: dateString)!
    }

    static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                          .withTime,
                                          .withDashSeparatorInDate,
                                          .withColonSeparatorInTime]
        return formatter
    }()
}
struct screen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let widthRatio = UIScreen.main.bounds.size.width / 320
    static let heightRatio = (UIScreen.main.bounds.size.height == 480) ?1 :(UIScreen.main.bounds.size.height / 568)
    static let maxLength = max(screen.width, screen.height)
    static let minLength = min(screen.width, screen.height)
}
