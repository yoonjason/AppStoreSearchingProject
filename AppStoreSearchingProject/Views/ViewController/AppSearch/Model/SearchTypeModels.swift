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

//enum SearchTypeModel {
//    case suggestWords(items: SearchTypeModels)
//    case recentSearchWords(items: SearchTypeModels)
//    case resultWords(items: SearchTypeModels)
//    case emptyResult(items: SearchTypeModels)
//}


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

//extension SearchTypeModel: SectionModelType {
//    typealias Item = SearchTypeModels
//
//    var items: [SearchTypeModels] {
//        switch self {
//        case .emptyResult(items: let items):
//            return items.title.map { $0 }
//        case .recentSearchWords(items: let items):
//            return items.title.map { $0 }
//        case .resultWords(items: let items):
//            return items.title.map { $0 }
//        case .suggestWords(items: let items):
//            return items.title.map { $0 }
//        }
//    }
//
//    init(original: SearchTypeModel, items: [SearchTypeModels]) {
//        switch original {
//        case .suggestWords(let items):
//            self = .suggestWords(items: items)
//        case .recentSearchWords(let items):
//            self = .recentSearchWords(items: items)
//        case .resultWords(let items):
//            self = .resultWords(items: items)
//        case .emptyResult(let items):
//            self = .emptyResult(items: items)
//        }
//    }
//
//
//}
