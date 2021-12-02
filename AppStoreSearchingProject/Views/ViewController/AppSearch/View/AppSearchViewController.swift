//
//  ViewController.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/26.
//  Copyright © 2020 yoon. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class AppSearchViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate, UISearchResultsUpdating, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var coordinator: AppSearchCoordinator?

    private var searchTypeModel: SearchTypeModels = .recentSearchWords
    private var searchResultItems = [AppData]()
    let searchController = UISearchController(searchResultsController: nil)
    private var appList = [AppData]()
    private var searchWords = [String]()
    private var recentSearchedWords = [String]()
    private var words: [Words] = WordDataManager.shared.getWords()
    private var currentInputAppName: String = ""
    private var firstId: Int64 = 0
    private var searchedTerm = String() {
        didSet {
            recentSearchedWords = wordsSearch(prefix: searchedTerm)
            tableView.reloadOnMainThread()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        requestGetAllWords()
        setView()
        registerCell()
        setSearchController()

    }

    func fetechAppInfo(_ endPoint: NetworkURLEndpoint.RawValue, queryItem: URLQueryItem, word: String) async throws -> Apps {
        let urlString = NetworkManager.shared.baseURL + endPoint
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var queryItems = [
            URLQueryItem(name: "term", value: word),
            URLQueryItem(name: "country", value: "kr"),
            URLQueryItem(name: "media", value: "software"),
            URLQueryItem(name: "entity", value: "software")
        ]
        queryItems.append(queryItem)
        var urlcomponents = URLComponents(string: encodedUrl!)
        urlcomponents?.queryItems = queryItems


        guard let url = URL(string: "") else { throw FetchError.invalidURL }

        let (data, _) = try await URLSession.shared.data(from: url)

        let iTuensResult = try JSONDecoder().decode(Apps.self, from: data)

        return iTuensResult

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

        setNeedsStatusBarAppearanceUpdate()

    }


    func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchBar.delegate = self
        searchController.isActive = true
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
//        navigationController?.navigationBar.isTranslucent = false
    }

    func searchAppInfo(_ title: String) {

        Task {
            do {
                let queryItem = URLQueryItem(name: "term", value: title)
                let apps = try await NetworkManager.shared.fetechAppInfo(NetworkURLEndpoint.search.rawValue, queryItem: queryItem)

                if let count = apps.resultCount, count > 0 {
                    guard let appsData = apps.results else { return }
                    self.searchResultItems = appsData
                    self.saveNewWords(id: firstId + 1 , word: title)
                    self.requestGetAllWords()
                    self.searchTypeModel = .resultWords
                    self.tableView.reloadData()
                    let indexPath = NSIndexPath(row: NSNotFound, section: 0)
                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
                } else {
                    self.searchTypeModel = .emptyResult
                    self.currentInputAppName = self.searchController.searchBar.text ?? ""
                    self.tableView.reloadData()
                }
            } catch {
                print("Request feiled with error: \(error)")
            }
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
            return searchResultItems.count
        case .emptyResult:
            return 1
        }
    }

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

            }
            customCell.tapped = {
                self.coordinator?.showDetailInfo(with: self.searchResultItems[indexPath.row])
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch searchTypeModel {
        case .suggestWords:
            self.searchAppInfo(recentSearchedWords[indexPath.row])
            searchController.searchBar.text = recentSearchedWords[indexPath.row]
        case .recentSearchWords:
            self.searchAppInfo(words[indexPath.row].word!)
            searchController.searchBar.text = words[indexPath.row].word!
        case .resultWords:
            coordinator?.showDetailInfo(with: searchResultItems[indexPath.row])
        default:
            print(indexPath.row)
        }
        searchController.searchBar.resignFirstResponder()
    }

}

//MARK: - SearchBar Method
extension AppSearchViewController {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let title = searchBar.text {
            searchAppInfo(title)
        }
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //캔슬 버튼을 눌렀을 때
        searchBar.resignFirstResponder()
        searchTypeModel = .recentSearchWords
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //타이핑을 하고 있을 때
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        if !recentSearchedWords.isEmpty {
            searchTypeModel = .suggestWords
            tableView.reloadData()
        }

        if let text = searchBar.text, text.isEmpty {
            searchTypeModel = .recentSearchWords
            tableView.reloadData()
        }
    }
}

//MARK: - CoreData Method
extension AppSearchViewController {

    fileprivate func requestGetAllWords() {
        let words: [Words] = WordDataManager.shared.getWords()
        self.words = words
        searchWords = words.map { $0.word! }
        if words.isEmpty {
            firstId = 0
        } else {
            firstId = words.first?.id ?? 0
        }
        self.tableView.reloadData()
    }

    fileprivate func saveNewWords(id: Int64, word: String) {
        if searchWords.contains(word) {
            return
        }
        WordDataManager.shared.saveWords(id: id, word: word, onSuccess: { (onSuccess) in
            print("Save Success ====== \(onSuccess)")
            self.requestGetAllWords()
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
        return words
            .map { $0.word! }
            .filter { $0.hasCaseInsensitivePrefix(prefix) }
            .sorted { $0 > $1 }
            .map { $0 }
    }
}
