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
    
    @IBOutlet weak var suggestTableView: UITableView!
    @IBOutlet weak var searchedTableView: UITableView!
    @IBOutlet weak var recentTableView: UITableView!
    var url = "https://itunes.apple.com/search?country=KR&media=software&term=라인&entity=software"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var searchWords = [String]()
    
   
    var appList = [AppList]()
    
    var searchedTerm = String(){
        didSet {
            currentWords = wordsSearch(prefix: searchedTerm)
            suggestTableView.reloadOnMainThread()
        }
    }
    private var currentWords = [String]()
    private var words :[Words] = WordDataManager.shared.getWords()
    var didSelect: (String) -> Void = { _ in }
//    lazy var searchBar : UISearchBar = UISearchBar(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        setCoreData()
        
        setView()
        setSearchController()
    }
    
    func wordsSearch(prefix: String) -> [String] {
        return words
            .map{ $0.word! }
            .filter { $0.hasCaseInsensitivePrefix(prefix) }
            .sorted{$0 > $1}
            .map    { $0 }
    }
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
        suggestTableView.isHidden = true
        suggestTableView.delegate = self
        suggestTableView.dataSource = self
        suggestTableView.rowHeight = UITableView.automaticDimension
        suggestTableView.estimatedRowHeight = 43.5
        
    }
    
    
    
    
    func setSearchController(){

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
        self.words = words
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
        fetchSearchList(searchWord: searchBar.text!)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchedTableView.isHidden = true
        suggestTableView.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        suggestTableView.isHidden = false
        searchedTableView.isHidden = true
        recentTableView.isHidden = true
        if searchText == "" {
            searchedTableView.isHidden = true
            suggestTableView.isHidden = true
            recentTableView.isHidden = false
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

                if let appList = appsList.results {
                    if appList.count > 0 {
                        self!.saveNewWords(id: 1, word: searchWord)
                        self?.appList = appList
                        
                    }
                    DispatchQueue.main.async { [weak self] in
                        let indexPath = NSIndexPath(row: NSNotFound, section: 0)
                        self!.searchedTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
                        self?.searchedTableView.isHidden = false
                        self?.searchedTableView.reloadData()
                        self?.suggestTableView.isHidden = true
                    }
                    
                    print("appsList", appsList)
                }
                self!.requestGetAllWords()
                DispatchQueue.main.async { [weak self] in
                    self?.recentTableView.reloadData()
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //searchController.searchBar.text  -> 텍스트 검색될 때 나오는 text optional
        guard let text = searchController.searchBar.text,
            !text.isEmpty else {
                return
        }
        searchedTerm = text
        
    }
    
}
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentTableView {
            return searchWords.count
        }else if tableView == searchedTableView {
            return appList.count
        }else if tableView == suggestTableView {
            return currentWords.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == recentTableView {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "RecentSearchTableViewCell", for: indexPath) as? RecentSearchTableViewCell
            let data = searchWords[indexPath.row]
            cell?.setData(data)
            cell?.selectionStyle = .none
            return cell!
        }else if tableView == searchedTableView {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell
            let appData = appList[indexPath.row]
            cell?.setData(appData: appData)
            cell?.selectionStyle = .none
            return cell!
        }else if tableView == suggestTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestedTableViewCell", for: indexPath) as! SuggestedTableViewCell
            cell.set(term: currentWords[indexPath.row],
                     searchedTerm: searchedTerm)
            cell.selectionStyle = .none
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == searchedTableView {
            return UITableView.automaticDimension
        }else if tableView == suggestTableView {
            return UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == recentTableView {
            self.fetchSearchList(searchWord: searchWords[indexPath.row])
            searchController.searchBar.text = searchWords[indexPath.row]
            navigationItem.hidesSearchBarWhenScrolling = true
        }
        if tableView == suggestTableView {
            didSelect(currentWords[indexPath.row])
            print(currentWords[indexPath.row])
        }
    }
    
    
}

