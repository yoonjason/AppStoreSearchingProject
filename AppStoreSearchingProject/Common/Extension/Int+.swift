//
//  Int+.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation

extension Int {

    var toDecimalFormat: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.locale = .current
        let formattedNumber = numberFormatter.string(from: NSNumber(value: self))
        return formattedNumber
    }

}
