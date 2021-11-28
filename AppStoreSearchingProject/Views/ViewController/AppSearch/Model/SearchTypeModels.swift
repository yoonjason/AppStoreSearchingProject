//
//  SearchTypeModels.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import RxDataSources

protocol EnumConvertable {
    var title: String { get }
}

enum SearchTypeModels: EnumConvertable {
    case suggestWords
    case recentSearchWords
    case resultWords
    case emptyResult

    var title: String {
        switch self {
        case .suggestWords:
            return "제안"
        case .recentSearchWords:
            return "최근 검색어"
        case .resultWords:
            return "검색 결과"
        case .emptyResult:
            return "검색 결과 없음"
        }
    }
}
