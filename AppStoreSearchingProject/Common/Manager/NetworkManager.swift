//
//  NetworkManager.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation

typealias NetworkResult = ((Result<Data, Error>) -> Void)

enum NetworkURLEndpoint: String {
    case search = "search?&country=kr&media=software&entity=software&"
    case review = "rss/customerreviews/page=1/id="
}


final class NetworkManager {

    private var baseURL: String


    static let shared = {
        NetworkManager(url: ServerPhaseManager.shared.serverURL)
    }()

    required init(url: String) {
        self.baseURL = url
    }

}

extension NetworkManager {

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
        print(urlcomponents?.url)
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
        print(urlcomponents?.url)
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
