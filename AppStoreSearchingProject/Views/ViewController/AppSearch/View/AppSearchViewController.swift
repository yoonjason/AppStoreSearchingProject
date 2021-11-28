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
import RxDataSources

class AppSearchViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate, UISearchResultsUpdating, UIScrollViewDelegate {

    @IBOutlet weak var notSearchedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var coordinator: AppSearchCoordinator?

    var searchTypeModel: SearchTypeModels = .recentSearchWords

    let searchedResultItems: BehaviorSubject<[AppData]> = BehaviorSubject<[AppData]>(value: [])
    let recentSearchItems: BehaviorSubject<[Words]> = BehaviorSubject<[Words]>(value: [])
    let suggestItems: BehaviorSubject<[String]> = BehaviorSubject<[String]>(value: [])
    let searchWords2: BehaviorSubject<[String]> = BehaviorSubject<[String]>(value: [])
    let currentWords2: BehaviorSubject<[String]> = BehaviorSubject<[String]>(value: [])

    var searchResultItems = [AppData]()

    let searchController = UISearchController(searchResultsController: nil)
    var appList = [AppData]()
    var searchedTerm = String() {
        didSet {
            recentSearchedWords = wordsSearch(prefix: searchedTerm)
            wordsSearch2(prefix: searchedTerm)
            tableView.reloadOnMainThread()
        }
    }

    private var searchWords = [String]()
    private var recentSearchedWords = [String]()
    private var words: [Words] = WordDataManager.shared.getWords()
    var currentInputAppName: String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        requestGetAllWords()
        registerCell()
        setSearchController()

//        NetworkManager.shared.get(urlString: "search?", word: "카카오") { result in
//            print(result)
//            if let data = try? JSONDecoder().decode(Apps.self, from: result) {
//                print(data.results?.count)
//                print(data.resultCount)
//            }
//
//        } failure: { error in
//            print(error)
//        }





//        tableView
//            .rx
//            .setDelegate(self)
//            .disposed(by: rx.disposeBag)
////
//        searchedResultItems
//            .bind(to: tableView.rx.items(cellIdentifier: "SearchResultCell", cellType: SearchResultCell.self)) { [weak self] index, item, cell in
//
////            cell.setData(appData: item)
//            cell.selectionStyle = .none
//        }
//            .disposed(by: rx.disposeBag)
////
//        Observable
//            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(AppData.self))
//            .bind { [weak self] (indexPath, item) in
//            self?.coordinator?.showDetailInfo(with: item)
//        }
//            .disposed(by: rx.disposeBag)
//
//
//        recentSearchItems
//            .bind(to: tableView.rx.items(cellIdentifier: "SearchWordCell", cellType: SearchWordCell.self)) { [weak self] (index, item, cell) in
//            cell.setData(item.word!)
//
//            cell.selectionStyle = .none
//        }
//            .disposed(by: rx.disposeBag)

//        suggestItems
//            .bind(to: tableView.rx.items(cellIdentifier: "SearchWordCell", cellType: SearchWordCell.self)) { (index, item, cell) in
//                cell.set(term: item, searchedTerm: self.searchedTerm )
//
//            cell.selectionStyle = .none
//        }
//            .disposed(by: rx.disposeBag)
//
//        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Words.self))
//            .bind { [weak self] (index, item) in
//            self?.fetchSearchList(searchWord: item.word!)
//            self?.searchController.searchBar.text = item.word
//            self?.navigationItem.hidesSearchBarWhenScrolling = false
//        }
//            .disposed(by: rx.disposeBag)



    }


    func registerCell() {
        self.tableView.registerCell(type: SearchWordCell.self)
        self.tableView.registerCell(type: SearchResultCell.self)
        self.tableView.registerCell(type: EmptyCell.self)
    }


    func setView() {
        definesPresentationContext = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 349
        tableView.rowHeight = UITableView.automaticDimension
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
        setNeedsStatusBarAppearanceUpdate()

    }

    func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchBar.delegate = self
        searchController.isActive = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationItem.hidesSearchBarWhenScrolling = true
    }

    func fetchSearchList(searchWord: String) {
        searchedResultItems.onNext([])
        APIService.shared.fetchfile(searchWord)
            .map { ($0?.results)! }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { searchedData in
            if searchedData.count > 0 {
                self.saveNewWords(id: 1, word: searchWord)
                self.searchedResultItems.onNext(searchedData)
                let indexPath = NSIndexPath(row: NSNotFound, section: 0)
                self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
                self.searchTypeModel = .resultWords
                self.requestGetAllWords()
            } else {
                self.searchedResultItems.onNext([])
//                self.notSearchedLabel.text = "`\(self.searchController.searchBar.text ?? "")`"
                self.searchTypeModel = .emptyResult
            }
        }, onError: { error in
            print(error)
        })
            .disposed(by: rx.disposeBag)
    }

    func searchApp(_ searchWord: String) {
        let quertyItem = URLQueryItem(name: "term", value: searchWord)
        NetworkManager.shared.requestAppSearch(NetworkURLEndpoint.search.rawValue, queryItem: quertyItem) { result in
            if let resultData = try? JSONDecoder().decode(Apps.self, from: result) {
                guard let appsData = resultData.results else { return }
                print(resultData.resultCount)
                if let count = resultData.resultCount, count > 0 {

                    self.searchResultItems = appsData
                    self.saveNewWords(id: 1, word: searchWord)
                    self.searchTypeModel = .resultWords
                    DispatchQueue.main.async {
                        self.requestGetAllWords()
                        self.tableView.reloadData()
                        let indexPath = NSIndexPath(row: NSNotFound, section: 0)
                        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
                    }
                }
                else {
                    self.searchTypeModel = .emptyResult
                    DispatchQueue.main.async {
                        self.currentInputAppName = self.searchController.searchBar.text ?? ""
                        self.tableView.reloadData()
                    }
                    
                }
            }
        } failure: { error in
            print(error)
        }
    }

}

//MARK: - UITableViewDelegate, DataSource
extension AppSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch searchTypeModel {
        case .suggestWords:
            return recentSearchedWords.count
        case .recentSearchWords:
            return words.count
        case .resultWords:
            print("searchResultItems === \(searchResultItems.count)")
            return searchResultItems.count
        case .emptyResult:
            return 1
        }
    }


//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()

        switch searchTypeModel {
        case .suggestWords:
            let customCell = self.tableView.dequeueCell(withType: SearchWordCell.self) as! SearchWordCell
            customCell.set(term: recentSearchedWords[indexPath.row], searchedTerm: searchedTerm)
            customCell.isSuggestEnabled = true
            cell = customCell
        case .recentSearchWords:
            let customCell = self.tableView.dequeueCell(withType: SearchWordCell.self) as! SearchWordCell
            customCell.isSuggestEnabled = false
            let data = words[indexPath.row]
            if let word = data.word {
                customCell.setData(word)
            }
            cell = customCell
        case .resultWords:
            let customCell = self.tableView.dequeueCell(withType: SearchResultCell.self) as! SearchResultCell
            let resultData = searchResultItems
            customCell.setData(appData: resultData[indexPath.row])
            customCell.tapped = {
                print("getget")
            }

            cell = customCell
        case .emptyResult:
            let customCell = self.tableView.dequeueCell(withType: EmptyCell.self) as! EmptyCell
            customCell.titleLabel.text = currentInputAppName
            cell = customCell
        }
        cell.selectionStyle = .none
        return cell


    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch searchTypeModel {
        case .resultWords:
            return 350
        case .emptyResult:
            return self.tableView.frame.size.height
        default:
            return UITableView.automaticDimension
        }
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch searchTypeModel {
        case .suggestWords:
            self.fetchSearchList(searchWord: recentSearchedWords[indexPath.row])
            self.searchApp(recentSearchedWords[indexPath.row])
            searchController.searchBar.text = recentSearchedWords[indexPath.row]
        case .recentSearchWords:
            self.searchApp(words[indexPath.row].word!)
            searchController.searchBar.text = words[indexPath.row].word!
        default:
            print(indexPath.row)
        }
        searchController.searchBar.resignFirstResponder()
    }

}

//MARK: - SearchBar Method
extension AppSearchViewController {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchSearchList(searchWord: searchBar.text!)
        if let word = searchBar.text {
            searchApp(word)
        }
        searchBar.resignFirstResponder()
        searchTypeModel = .resultWords
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //캔슬 버튼을 눌렀을 때
        searchBar.resignFirstResponder()
        searchTypeModel = .recentSearchWords
        tableView.reloadData()
        print("Cancel")
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }

    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //타이핑을 하고 있을 때

        if !recentSearchedWords.isEmpty {
            searchTypeModel = .suggestWords
            tableView.reloadData()
        }

        if let text = searchBar.text, text.isEmpty {
            searchTypeModel = .recentSearchWords
            tableView.reloadData()
        }
        print(#function)
    }
}

//MARK: - CoreData Method
extension AppSearchViewController {

    fileprivate func requestGetAllWords() {
        let words: [Words] = WordDataManager.shared.getWords()
        recentSearchItems.onNext(words)
        self.words = words
//            let wordName: [String] = words.map { $0.word! }
        searchWords = words.map { $0.word! }
//            searchWords2.onNext(words.map { $0.word! })
        print(self.words.count)
        self.setView()
        self.tableView.reloadData()
    }

    fileprivate func saveNewWords(id: Int64, word: String) {
        if searchWords.contains(word) {
            return
        }
        WordDataManager.shared.saveWords(id: id, word: word, onSuccess: { (onSuccess) in
            print("Save Success ====== \(onSuccess)")
        })
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
            !text.isEmpty else {
            return
        }
        searchedTerm = text
    }

    func wordsSearch(prefix: String) -> [String] {
//        recentSearchItems.onNext()
//        var tt = words
//            .map { $0.word! }
//            .filter { $0.hasCaseInsensitivePrefix(prefix) }
//            .sorted { $0 > $1 }
//            .map { $0 }
//        suggestItems.onNext(tt)
        return words
            .map { $0.word! }
            .filter { $0.hasCaseInsensitivePrefix(prefix) }
            .sorted { $0 > $1 }
            .map { $0 }
    }
    func wordsSearch2(prefix: String) {
        suggestItems.onNext(words
            .map { $0.word! }
            .filter { $0.hasCaseInsensitivePrefix(prefix) }
            .sorted { $0 > $1 }
            .map { $0 })
    }
}
