//
//  AppSearchViewModel.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import RxSwift

class AppSearchViewModel {
    
    
    var searchType: BehaviorSubject<SearchTypeModels> = BehaviorSubject<SearchTypeModels>(value: SearchTypeModels.recentSearchWords)
    
}
