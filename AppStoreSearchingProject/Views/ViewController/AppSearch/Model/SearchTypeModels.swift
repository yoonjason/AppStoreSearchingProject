//
//  SearchTypeModels.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation

protocol EnumConvertable {
    var title: String { get }
}

enum SearchTypeModels: EnumConvertable {
    case segguestWords
    case recentSearchWords
    case resultWords
    case emptyResult

    var title: String {
        switch self {
        case .segguestWords:
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
