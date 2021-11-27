//
//  String+.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation


extension String {

    func hasCaseInsensitivePrefix(_ s: String) -> Bool {
        return prefix(s.count).caseInsensitiveCompare(s) == .orderedSame
    }
}
