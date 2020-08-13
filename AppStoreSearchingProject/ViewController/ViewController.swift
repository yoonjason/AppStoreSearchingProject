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
import RxSwift
import RxCocoa
import NSObject_Rx

class SearchResultViewModel {
//    let appsData = BehaviorSubject<Apps>(value: Apps(from: <#T##Decoder#>))
}

class ViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var notSearchedLabel: UILabel!
    @IBOutlet weak var suggestTableView: UITableView!
    @IBOutlet weak var searchedTableView: UITableView!
    @IBOutlet weak var recentTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var appList = [AppData]()
    var searchedTerm = String(){
        didSet {
            currentWords = wordsSearch(prefix: searchedTerm)
            suggestTableView.reloadOnMainThread()
        }
    }
    private var searchWords = [String]()
    private var currentWords = [String]()
    private var words :[Words] = WordDataManager.shared.getWords()
    
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
        emptyView.isHidden = true
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
        setNeedsStatusBarAppearanceUpdate()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    func setCoreData() {
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
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        emptyView.isHidden = true
        recentTableView.isHidden = false
        searchedTableView.isHidden = true
        suggestTableView.isHidden = true
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        emptyView.isHidden = true
        suggestTableView.isHidden = false
        searchedTableView.isHidden = true
        recentTableView.isHidden = true
        if searchText == "" {
            searchedTableView.isHidden = true
            suggestTableView.isHidden = true
            recentTableView.isHidden = false
        }
    }
    
    func fetchSearchList(searchWord : String ){
        self.emptyView.isHidden = true
//        APIService.shared.fetchfile(searchWord)
//            .subscribe(onNext : { apps in
//                if let appList = apps?.results {
//                    self.appList.removeAll()
//                    self.appList = appList
//
//                }
//            })
//            .disposed(by: rx.disposeBag)
        
        
            
            
        
        APIService.shared.fetchAppsSearch(searchWord : searchWord) { [weak self] (apps, error) in
            if let error = error {
                print("Failed to search apps: ", error)
                return
            }
            
            if let appList = apps?.results {
                self?.appList.removeAll()
                if appList.count > 0 {
                    self!.saveNewWords(id: 1, word: searchWord)
                    self?.appList = appList
                }

                DispatchQueue.main.async { [weak self] in
                    if appList.count < 1 {
                        self?.notSearchedLabel.text = "`\(self?.searchController.searchBar.text ?? "")`"
                        self!.emptyView.isHidden = false
                        self?.searchedTableView.isHidden = true
                        self?.recentTableView.isHidden = true
                        self?.suggestTableView.isHidden = true
                    }
                    let indexPath = NSIndexPath(row: NSNotFound, section: 0)
                    self!.searchedTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
                    self?.searchedTableView.isHidden = false
                    self?.searchedTableView.reloadData()
                    self?.suggestTableView.isHidden = true
                }
                
            }
            self!.requestGetAllWords()
            DispatchQueue.main.async { [weak self] in
                self?.recentTableView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
            !text.isEmpty else {
                return
        }
        searchedTerm = text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromMainToDetail" {
            if let destinationVC = segue.destination as? DetailViewController {
                if let data = sender as? AppData {
                    destinationVC.data = data
                    destinationVC.appId = data.trackId!
                }
            }
        }
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
            self.fetchSearchList(searchWord: currentWords[indexPath.row])
            searchController.searchBar.text = currentWords[indexPath.row]
        }
        
        if tableView == searchedTableView {
            performSegue(withIdentifier: "FromMainToDetail", sender: appList[indexPath.row])
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    
}

