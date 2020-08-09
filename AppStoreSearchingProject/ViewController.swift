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

class ViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var searchedTableView: UITableView!
    @IBOutlet weak var recentTableView: UITableView!
    var url = "https://itunes.apple.com/search?country=KR&media=software&term=라인&entity=software"
    
    
    func updateSearchResults(for searchController: UISearchController) {
        //searchController.searchBar.text  -> 텍스트 검색될 때 나오는 text optional
        //        searchController.searchResultsController.
        //        print()
        
    }
    var searchWords = [String]()
    var appList = [AppList]()
    var isSearched = false
    
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
        setSearchController()
    }
    //https://itunes.apple.com/search?country=KR&media=software&term=kakao&entity=software
    
    func setView(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never

//        search.searchBar.autocapitalizationType = .none
        
        definesPresentationContext = true
        recentTableView.delegate = self
        recentTableView.dataSource = self
        searchedTableView.dataSource = self
        searchedTableView.delegate = self
        searchedTableView.isHidden = true
        searchedTableView.estimatedRowHeight = 349
        searchedTableView.rowHeight = UITableView.automaticDimension
    }
    
    func setSearchController(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "App Store"
        searchController.searchBar.delegate = self
        searchController.isActive = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setCoreData() {
        //        saveNewWords(id: 1, word: "카카오")
        
        requestGetAllWords()
    }
    
    fileprivate func requestGetAllWords() {
        let words : [Words] = WordDataManager.shared.getWords()
        let wordName :[String] = words.map{$0.word!}
        searchWords = words.map{$0.word!}
        print("All Searching words...\(wordName)")
    }
    
    fileprivate func saveNewWords(id : Int64, word : String){
        if searchWords.contains(word) {
            return
        }
        WordDataManager.shared.saveWords(id: id, word: word, onSuccess: { (onSuccess) in
            print("Save Success ====== \(onSuccess)")
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text)
        fetchSearchList(searchWord: searchBar.text!)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText == "" {
            searchedTableView.isHidden = true
        }
    }
    
    
    func fetchSearchList(searchWord : String) {
        //https://itunes.apple.com/search?term=카카오톡&country=kr&media=software
        let urlString = "https://itunes.apple.com/search?term=\(searchWord)&country=kr&media=software"
        DispatchQueue.main.async {
            //          UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: encodedUrl!) else {
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
                let appsList = try decoder.decode(Apps.self, from: data)
                
                
                self!.requestGetAllWords()
                DispatchQueue.main.async { [weak self] in
                    self?.recentTableView.reloadData()
                }
                if let appList = appsList.results {
                    if appList.count > 0 {
                        self!.saveNewWords(id: 1, word: searchWord)
                        self?.appList = appList
                        
                    }
                    appList.forEach{
                        print($0.trackName)
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.searchedTableView.scrollsToTop = true
                        self?.searchedTableView.isHidden = false
                        self?.searchedTableView.reloadData()
                    }
                    
                    print("appsList", appsList)
                }
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
        }else if tableView == searchedTableView {
            return appList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == recentTableView {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell
            let data = searchWords[indexPath.row]
            cell?.titleBtn.setTitle(data, for: .normal)
            cell?.selectionStyle = .none
            return cell!
        }else if tableView == searchedTableView {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell
            let appData = appList[indexPath.row]
            cell?.setData(appData: appData)
            cell?.selectionStyle = .none
            return cell!
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == searchedTableView {
            return UITableView.automaticDimension
        }
        return 30
    }
    
    
}

