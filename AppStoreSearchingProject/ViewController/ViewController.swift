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

class ViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate, UISearchResultsUpdating, UIScrollViewDelegate {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var notSearchedLabel: UILabel!
    @IBOutlet weak var suggestTableView: UITableView!
    @IBOutlet weak var searchedTableView: UITableView!
    @IBOutlet weak var recentTableView: UITableView!
    
    let searchedResultItems : BehaviorSubject<[AppData]> = BehaviorSubject<[AppData]>(value: [])
    let recentSearchItems : BehaviorSubject<[Words]> = BehaviorSubject<[Words]>(value: [])
    let searchWords2 : BehaviorSubject<[String]> = BehaviorSubject<[String]>(value: [])
    let currentWords2 : BehaviorSubject<[String]> = BehaviorSubject<[String]>(value: [])
    
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
        
        searchedResultItems
            .bind(to: searchedTableView.rx.items(cellIdentifier: "SearchResultCell", cellType: SearchResultCell.self)) { [weak self] index, item, cell in
                cell.setData(appData: item)
                cell.selectionStyle = .none
        }
        .disposed(by: rx.disposeBag)
               
        Observable
            .zip(searchedTableView.rx.itemSelected, searchedTableView.rx.modelSelected(AppData.self))
            .bind{ [weak self] (indexPath, item)  in
                self?.performSegue(withIdentifier: "FromMainToDetail", sender: item)
        }
        .disposed(by: rx.disposeBag)
        
        searchedTableView
            .rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        
        recentSearchItems
            .bind(to: recentTableView.rx.items(cellIdentifier: "RecentSearchTableViewCell", cellType: RecentSearchTableViewCell.self)) { [weak self] (index, item, cell) in
                cell.setData(item.word!)
                cell.selectionStyle = .none
        }
        .disposed(by: rx.disposeBag)
        
        Observable.zip(recentTableView.rx.itemSelected, recentTableView.rx.modelSelected(Words.self))
            .bind{ [weak self] (index, item) in
                self?.fetchSearchList(searchWord: item.word!)
                self?.searchController.searchBar.text = item.word
                self?.navigationItem.hidesSearchBarWhenScrolling = true
        }
        .disposed(by: rx.disposeBag)
        
        recentTableView
            .rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
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
        recentSearchItems.onNext(words)
       
        
        self.words = words
        let wordName :[String] = words.map{$0.word!}
        searchWords = words.map{$0.word!}
        searchWords2.onNext(words.map{$0.word!})
        
//        print("All Searching words...\(wordName)")
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
        
        searchedResultItems.onNext([])
        APIService.shared.fetchfile(searchWord)
            .map{ ($0?.results)! }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { searchedData in
                if searchedData.count > 0 {
                    self.saveNewWords(id: 1, word: searchWord)
                    self.searchedResultItems.onNext(searchedData)
                    let indexPath = NSIndexPath(row: NSNotFound, section: 0)
                    self.searchedTableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
                    self.searchedTableView.isHidden = false
                    self.suggestTableView.isHidden = true
                    self.requestGetAllWords()
                }else {
                    self.searchedResultItems.onNext([])
                    self.notSearchedLabel.text = "`\(self.searchController.searchBar.text ?? "")`"
                    self.emptyView.isHidden = false
                    self.searchedTableView.isHidden = true
                    self.recentTableView.isHidden = true
                    self.suggestTableView.isHidden = true
                }
            }, onError: { error in
                print(error)
            })
            .disposed(by: rx.disposeBag)
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
        return currentWords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestedTableViewCell", for: indexPath) as! SuggestedTableViewCell
        cell.set(term: currentWords[indexPath.row],
                 searchedTerm: searchedTerm)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == suggestTableView {
            self.fetchSearchList(searchWord: currentWords[indexPath.row])
            searchController.searchBar.text = currentWords[indexPath.row]
        }

        searchController.searchBar.resignFirstResponder()
    }


}

