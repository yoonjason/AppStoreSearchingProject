//
//  DeatilTypeModel.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/28.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation

enum DetailTypeModels: EnumConvertable {
    case info
    case newFeature
    case preview
    case description
    case infomation
    case review

    var title: String {
        switch self {
        case .info:
            return ""
        case .newFeature:
            return ""
        case .preview:
            return ""
        case .description:
            return ""
        case .infomation:
            return ""
        case .review:
            return ""
        }
    }


}
