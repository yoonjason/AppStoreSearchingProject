//
//  NetworkManager.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation

typealias NetworkResult = ((Result<Data, Error>) -> Void)

enum Request: CustomStringConvertible {
    case get
    case post
    case delete

    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        }
    }
}

protocol NetworkService {
    func request(request type: Request, url: String, body: Data?, completion: @escaping NetworkResult)
}

final class NetworkManager {

    private var baseURL: URL?


    static let shared = {
        NetworkManager(url: ServerPhaseManager.shared.serverURL)
    }()

    required init(url: String) {
        self.baseURL = URL(string: url)
    }

}

extension NetworkManager: NetworkService {
    

    func request(request type: Request = .get, url: String, body: Data?, completion: @escaping NetworkResult) {
        
        if let aburl = baseURL?.absoluteString {
            print(aburl+url)
        }
        
        guard let url = URL(string: baseURL?.absoluteString ?? "" + url) else {
            print("FAIL!!!!")
            return
        }
        print(url)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = type.description
        urlRequest.httpBody = body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
//                completion(.failure(.unknownError(message: error?.localizedDescription ?? "Unkown")))
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200..<300).contains(response.statusCode) else {
//                completion(.failure(.unsuccessfulResponse))
                return
            }
            guard let data = data else {
//                completion(.failure(.APIInvalidResponse))
                return
            }
            completion(.success(data))
        }.resume()
    }

    func get<T:Decodable>(urlString endpoint: String, word: String, success: @escaping (T) -> Void, failure: @escaping (Error) -> Void) {

        //https://itunes.apple.com/search?term=\(searchWord)&country=kr&media=software&entity=software
        let urlString: String
        if endpoint.hasPrefix("http") {
            urlString = endpoint
        }
        else {
            guard let url = URL(string: endpoint, relativeTo: self.baseURL as URL?) else {
                return
            }
            urlString = url.absoluteString
        }
        var urlcomponents = URLComponents(string: urlString)
        let name = URLQueryItem(name: "term", value: word)
        urlcomponents?.queryItems?.append(name)

        guard let requestURL = urlcomponents?.url else { return }
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                success(result)
            }
            catch let jsonError {
                failure(jsonError)
            }
        }
            .resume()
    }

}
