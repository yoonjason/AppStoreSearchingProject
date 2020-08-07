//
//  ViewController.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/05.
//  Copyright © 2020 yoon. All rights reserved.
//

import UIKit
import Foundation
import CoreData

let MEMBER_LIST_URL = "https://itunes.apple.com/search?country=KR&"

class ViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var recentTableView: UITableView!
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    var searchWords = [String]()
    
    lazy var searchBar : UISearchBar = UISearchBar(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let url = URL(string: MEMBER_LIST_URL + "&media=software&term=kakao&entity=software")!
//        let data = try! Data(contentsOf: url)
//        let json = String(data: data, encoding: .utf8)
//        print(json)
//
        setCoreData()
        setView()
    }
    //https://itunes.apple.com/search?country=KR&media=software&term=kakao&entity=software
    
    func setView(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "App Store"
        self.navigationItem.searchController = search
        definesPresentationContext = true
        recentTableView.delegate = self
        recentTableView.dataSource = self
    }
    
    func setCoreData() {
//        saveNewWords(id: 1, word: "카카ㅇ")
        
        requestGetAllWords()
    }
    
    fileprivate func requestGetAllWords() {
        let words : [Words] = WordDataManager.shared.getWords()
        let wordName :[String] = words.map{$0.word!}
        searchWords = words.map{$0.word!}
        print("All Searching words...\(wordName)")
    }
    
    fileprivate func saveNewWords(id : Int64, word : String){
        WordDataManager.shared.saveWords(id: id, word: word, onSuccess: { (onSuccess) in
            print("Save Success ====== \(onSuccess)")
        })
    }
    

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
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentTableView {
            return searchWords.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath) as? RecentSearchCell
        let data = searchWords[indexPath.row]
        cell?.titleBtn.setTitle(data, for: .normal)
        
        return cell!
    }
    
    
}


extension UINavigationController {
    @IBInspectable var navigationLargeTitleBarColor : UIColor {
        set {
            self.view.backgroundColor = newValue
        }
        get {
            return self.view.backgroundColor ?? UIColor.black
        }
    }
}
