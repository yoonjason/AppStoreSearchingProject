//
//  ViewController.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/05.
//  Copyright © 2020 yoon. All rights reserved.
//

import UIKit

let MEMBER_LIST_URL = "https://itunes.apple.com/search?country=KR&"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: MEMBER_LIST_URL + "&media=software&term=kakao&entity=software")!
        let data = try! Data(contentsOf: url)
        let json = String(data: data, encoding: .utf8)
        print(json)
    }
    //https://itunes.apple.com/search?country=KR&media=software&term=kakao&entity=software

    func fetchBookList() {
       DispatchQueue.main.async {
//          UIApplication.shared.isNetworkActivityIndicatorVisible = true
       }
       
       guard let url = URL(string: MEMBER_LIST_URL) else {
          fatalError("Invalid URL")
       }
       
       let session = URLSession.shared
       
       let task = session.dataTask(with: url) { [weak self] (data, response, error) in
          defer {
             DispatchQueue.main.async { [weak self] in
//                self?.listTableView.reloadData()
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
             }
          }
          
          if let error = error {
             print(error)
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
          
          guard let data = data else {
             fatalError("Invalid Data")
          }
          
          do {
             let decoder = JSONDecoder()
//             let bookList = try decoder.decode(BookList.self, from: data)
             
//             if bookList.code == 200 {
//                self?.list = bookList.list
//             } else {
//                self?.list = [Book]()
//             }
          } catch {
             print(error)
          }
       }
       task.resume()
    }

}

