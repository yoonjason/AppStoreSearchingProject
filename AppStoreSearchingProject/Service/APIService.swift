//
//  Service.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/10.
//  Copyright © 2020 yoon. All rights reserved.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    func fetchAppsSearch(searchWord: String, completion: @escaping (Apps?, Error?) -> ()) {
      let urlString = "https://itunes.apple.com/search?term=\(searchWord)&country=kr&media=software&entity=software"
      fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: encodedUrl!) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid Response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print(httpResponse.statusCode)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result, nil)
            } catch let jsonError {
                print("Failed to fetch apps: ", jsonError)
            }
        }.resume()
    }
    
   
}
