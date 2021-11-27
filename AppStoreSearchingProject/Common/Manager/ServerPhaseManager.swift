//
//  ServerPhaseManager.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation

final class ServerPhaseManager {
    
    static let shared = ServerPhaseManager()
    
    var serverURL: String {
        get {
            return "https://itunes.apple.com/"
        }
    }
}
