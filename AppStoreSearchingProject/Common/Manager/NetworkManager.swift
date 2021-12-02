//
//  NetworkManager.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

enum NetworkURLEndpoint: String {
    case search = "search?&country=kr&media=software&entity=software&"
    case review = "rss/customerreviews/page=1/id="
}

enum FetchError: Error {
    case invalidURL
    case invalidImage
    case invalidResponse
    case missingData
}


final class NetworkManager {

    var baseURL: String


    static let shared = {
        NetworkManager(url: ServerPhaseManager.shared.serverURL)
    }()

    required init(url: String) {
        self.baseURL = url
    }

}

extension NetworkManager {

    func fetechAppInfo(_ endPoint: NetworkURLEndpoint.RawValue, queryItem: URLQueryItem) async throws -> Apps {
        let urlString = NetworkManager.shared.baseURL + endPoint
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var queryItems = [
            URLQueryItem(name: "country", value: "kr"),
            URLQueryItem(name: "media", value: "software"),
            URLQueryItem(name: "entity", value: "software")
        ]
        queryItems.append(queryItem)
        var urlcomponents = URLComponents(string: encodedUrl!)
        urlcomponents?.queryItems = queryItems
        guard let url = urlcomponents?.url else { throw FetchError.invalidURL }
//        let (data, response) = try await URLSession.shared.data(from: url)
//        let resultApps = try JSONDecoder().decode(Apps.self, from: data)
        let resultData: Apps = try await fetch(url)
        return resultData
    }
    
    
    func fetchReview(with endPoint: NetworkURLEndpoint.RawValue, appId: Int) async throws -> Review {
        let urlString = baseURL + endPoint + "\(appId)/sortby=mostrecent/json?l=ko&cc=kr"
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlcomponents = URLComponents(string: encodedUrl!)
        guard let url = urlcomponents?.url else { throw FetchError.invalidURL }
//        var fp: Review = try await fetch(url)
//        return fp
        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw FetchError.invalidResponse }
        guard let resultData = try? JSONDecoder().decode(Review.self, from: data) else { throw FetchError.missingData }
        return resultData
    }
    
    func fetch<T:Codable>(_ url: URL) async throws -> T  {
        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw FetchError.invalidResponse }
        guard let result = try? JSONDecoder().decode(T.self, from: data) else { throw FetchError.missingData }
        return result
    }

    func fetchImage(with urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw FetchError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.invalidResponse
        }

        guard let image = await UIImage(data: data, scale: UIScreen.main.scale) else {
            throw FetchError.invalidImage
        }

        return image
    }



    func requestAppSearch(_ endPoint: NetworkURLEndpoint.RawValue, queryItem: URLQueryItem, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) {
        let urlString = baseURL + endPoint
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var queryItems = [
            URLQueryItem(name: "country", value: "kr"),
            URLQueryItem(name: "media", value: "software"),
            URLQueryItem(name: "entity", value: "software")
        ]
        queryItems.append(queryItem)

        var urlcomponents = URLComponents(string: encodedUrl!)
        urlcomponents?.queryItems = queryItems
        guard let requestURL = urlcomponents?.url else { return }
        get(requestURL) { result in
            success(result)
        } failure: { error in
            failure(error)
        }
    }

    func requestAppReview(_ endPoint: NetworkURLEndpoint.RawValue, appId: Int, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) {
        let urlString = baseURL + endPoint + "\(appId)/sortby=mostrecent/json?l=ko&cc=kr"
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlcomponents = URLComponents(string: encodedUrl!)
        guard let requestURL = urlcomponents?.url else { return }
        get(requestURL) { result in
            print("#@# === success")
            success(result)
        } failure: { error in
            print("#@# === error")
            failure(error)
        }
    }


    fileprivate func get(_ requestURL: URL, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) {

        URLSession.shared.dataTask(with: requestURL) { data, response, error in

            guard error == nil else {
                //                completion(.failure(.unknownError(message: error?.localizedDescription ?? "Unkown")))
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200..<300).contains(response.statusCode) else {
                //                completion(.failure(.unsuccessfulResponse))
                return
            }
            guard let data = data else { return }
            success(data)
        }
            .resume()
    }


}
