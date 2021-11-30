//
//  ImageViewModel.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/30.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

enum ImageDownloadError: Error {
    case invalidURLString
    case invalidImage
    case invalidResponse
}

class ImageViewModel {
    func fetchImage(with urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw ImageDownloadError.invalidURLString
        }

        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ImageDownloadError.invalidResponse
        }

        guard let image = await UIImage(data: data, scale: UIScreen.main.scale) else {
            throw ImageDownloadError.invalidImage
        }

        return image
    }
}

