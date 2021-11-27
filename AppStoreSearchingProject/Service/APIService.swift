//
//  Service.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/10.
//  Copyright © 2020 yoon. All rights reserved.
//

import Foundation
import RxSwift
import NSObject_Rx

class APIService {
    static let shared = APIService()
    
    
    func fetchAppsSearch(searchWord: String, completion: @escaping (Apps?, Error?) -> ()) {
      let urlString = "https://itunes.apple.com/search?term=\(searchWord)&country=kr&media=software&entity=software"
      fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
//    func fetchSearch(searchWord : String, completion : @escaping ()
    
    func getFetchAppReviewCountInfo(_ appId : Int){
        let urlString = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId)/sortby=mostrecent/json?l=ko&cc=kr"
        fetchGenericJSONData(urlString: urlString) { [weak self] (reviews: Review?, error) in
            if let error = error {
                print("Failed to fetch reviews: ", error)
                return
            }
            
        }
    }
    
    func fetchReviews(_ appId : Int) -> Observable<Review?> {
        return Observable.create{ emitter in
            let urlString = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId)/sortby=mostrecent/json?l=ko&cc=kr"
            let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: encodedUrl!)
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                guard let data = data else {return}
                do {
                    let result = try JSONDecoder().decode(Review.self, from: data)
                    emitter.onNext(result)
                    emitter.onCompleted()
                }
                catch let jsonError {
                    emitter.onError(jsonError)
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func fetchfile(_ searchWord : String) -> Observable<Apps?> {
        return Observable.create{ emitter in
            let urlString = "https://itunes.apple.com/search?term=\(searchWord)&country=kr&media=software&entity=software"
            let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: encodedUrl!)
            let task = URLSession.shared.dataTask(with: url!) { data, _, error in

                guard let data = data else { return }
                do {
                    let result = try JSONDecoder().decode(Apps.self, from: data)
                    emitter.onNext(result)
                    emitter.onCompleted()
                }
                catch let jsonError {
                    emitter.onError(jsonError)
                    print("Failed to fetch apps: ", jsonError)
                }
            }
            task.resume()
            return Disposables.create{
                task.cancel()
            }
            
        }
    
        
        
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
