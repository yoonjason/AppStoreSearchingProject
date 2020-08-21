//
//  DetailViewController.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/09.
//  Copyright © 2020 yoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

protocol TableCellProtocol : class {
    func pageMove() -> Void
    func showCell(index : Int) -> Void
}

extension DetailViewController : TableCellProtocol {
    func pageMove() {
        performSegue(withIdentifier: "FromMainToScreenShotDetail", sender: data)
    }
    func showCell(index : Int) {
        print(index)
    }
}

class DetailViewController: UIViewController {
    
    var data : AppData?
    var expandedIdxSet : IndexSet = []
    var appId : Int = 0
    var entry : [Entry] = [Entry]()
    var entryData : BehaviorSubject<[Entry]> = BehaviorSubject<[Entry]>(value: [])
    var didSelect: (String) -> Void = { _ in }
//    var dataOb : Observable<AppData> = Observable<AppData>()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        getFetchAppReviewCountInfo()
        
//        tableView
//            .rx
//            .setDelegate(self)
//            .disposed(by: rx.disposeBag)
        
        
//        dataOb.asObservable().bin
        
        
//
//        entryData.bind(to: tableView.rx.items){ (tableView, row, item) -> UITableViewCell in
//            if row == 0 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "AppDetailTopInfoCell", for: IndexPath.init(row: row, section: 0)) as! AppDetailTopInfoCell
//                cell.setView(data: self.data!)
//                cell.selectionStyle = .none
//                return cell
//            }else if row == 1 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "NewFeatureInfoCell", for: IndexPath.init(row: row, section: 0)) as! NewFeatureInfoCell
//                cell.setData(self.data!)
//                cell.delegate = self
//                if self.expandedIdxSet.contains(1) {
//                    cell.descLabel.numberOfLines = 0
//                } else {
//                    cell.descLabel.numberOfLines = 2
//                }
//                return cell
//            }else if row == 2 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "PreViewTableViewCell", for: IndexPath.init(row: row, section: 0)) as! PreViewTableViewCell
//                cell.setData(self.data!)
//                cell.delegate = self
//                cell.selectionStyle = .none
//                return cell
//            }else if row == 3 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "AppDescriptionCell", for: IndexPath.init(row: row, section: 0)) as! AppDescriptionCell
//                cell.setData(self.data!)
//                if self.expandedIdxSet.contains(3) {
//                    cell.descriptionLabel.numberOfLines = 0
//                } else {
//                    cell.descriptionLabel.numberOfLines = 2
//                }
//                cell.selectionStyle = .none
//                return cell
//            }else if row == 4 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "AppReviewCell", for: IndexPath.init(row: row, section: 0)) as! AppReviewCell
//
//                cell.setData(self.appId)
//                cell.selectionStyle = .none
//                _ = self.entryData
//                    .map{ entry in
//                        if entry.count < 1 {
//                            cell.isHidden = true
//                        }
//                }
//
//
//                return cell
//            }else if row == 5 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "AppInfomationCell", for: IndexPath.init(row: row, section: 0)) as! AppInfomationCell
//                cell.setData(self.data!)
//                cell.selectionStyle = .none
//                return cell
//            }
//            return UITableViewCell()
//        }
//        .disposed(by: rx.disposeBag)
//
//
//        tableView
//            .rx
//            .itemSelected
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext : { [weak self] (indexPath) in
//
//                if indexPath.row == 1{
//                    self?.tableView.deselectRow(at: indexPath, animated: false)
//
//                    if(self!.expandedIdxSet.contains(indexPath.row)){
//                        self!.expandedIdxSet.remove(indexPath.row)
//                    } else {
//                        self!.expandedIdxSet.insert(indexPath.row)
//                    }
//
//                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
//                }
//                else if indexPath.row == 2 {
//                    print("SELECT")
//                    self?.performSegue(withIdentifier: "FromMainToScreenShotDetail", sender: nil)
//                }
//                else if indexPath.row == 3 {
//                    self?.tableView.deselectRow(at: indexPath, animated: false)
//
//                    if(self!.expandedIdxSet.contains(indexPath.row)){
//                        self!.expandedIdxSet.remove(indexPath.row)
//                    } else {
//                        self!.expandedIdxSet.insert(indexPath.row)
//                    }
//
//                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
//                }
//            })
//            .disposed(by: rx.disposeBag)
        
    }
    
    func setView(){
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.largeTitleDisplayMode = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 280.0
    }
    
    func getFetchAppReviewCountInfo(){
        let urlString = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId)/sortby=mostrecent/json?l=ko&cc=kr"
        APIService.shared.fetchGenericJSONData(urlString: urlString) { [weak self] (reviews: Review?, error) in
            if let error = error {
                print("Failed to fetch reviews: ", error)
                return
            }
            if let entry = reviews?.feed.entry {
                self?.entry = entry
            }
        }
        APIService.shared.fetchReviews(appId)
            .subscribe(onNext:{ [weak self] data in
                if let entry = data?.feed.entry {
                    if entry.count > 0 {
                        self?.entryData.onNext(entry)
                    }else {
                        self?.entryData.onNext([])
                    }
                }
                }, onError: { error in
                    print("errorerror", error)
                    self.entryData.onNext([Entry(author: Author(name: Label(label: "")), title: Label(label: ""), content: Label(label: ""), rating: Label(label: ""))])
            })
            .disposed(by: rx.disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromMainToScreenShotDetail" {
            if let destinationVC = segue.destination as? ScreenShotDetailViewController {
                destinationVC.data = data
                if let imageUrls = data?.screenshotUrls {
                    destinationVC.imagesUrl = imageUrls
                }
            }
        }
    }
    
}

extension DetailViewController : UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "AppDetailTopInfoCell", for: indexPath) as! AppDetailTopInfoCell
            cell.setView(data: data!)
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewFeatureInfoCell", for: indexPath) as! NewFeatureInfoCell
            cell.setData(data!)
            cell.delegate = self
            if expandedIdxSet.contains(1) {
                cell.descLabel.numberOfLines = 0
            } else {
                cell.descLabel.numberOfLines = 2
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreViewTableViewCell", for: indexPath) as! PreViewTableViewCell
            cell.setData(data!)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppDescriptionCell", for: indexPath) as! AppDescriptionCell
            cell.setData(data!)
            if expandedIdxSet.contains(3) {
                cell.descriptionLabel.numberOfLines = 0
            } else {
                cell.descriptionLabel.numberOfLines = 2
            }
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppReviewCell", for: indexPath) as! AppReviewCell

            cell.setData(appId)
            cell.selectionStyle = .none
            if entry.count < 1 {
                cell.isHidden = true
            }

            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppInfomationCell", for: indexPath) as! AppInfomationCell
            cell.setData(data!)
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 1{
            tableView.deselectRow(at: indexPath, animated: false)

            if(expandedIdxSet.contains(indexPath.row)){
                expandedIdxSet.remove(indexPath.row)
            } else {
                expandedIdxSet.insert(indexPath.row)
            }

            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        else if indexPath.row == 2 {
            print("SELECT")
            performSegue(withIdentifier: "FromMainToScreenShotDetail", sender: nil)
        }
        else if indexPath.row == 3 {
            tableView.deselectRow(at: indexPath, animated: false)

            if(expandedIdxSet.contains(indexPath.row)){
                expandedIdxSet.remove(indexPath.row)
            } else {
                expandedIdxSet.insert(indexPath.row)
            }

            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 230
        case 1:
            return UITableView.automaticDimension
        case 2:
            return 534
        case 3:
            return UITableView.automaticDimension
        case 4:
            if entry.count < 1 {
                return 0
            }
            return 282
        case 5:
            return 251
        default:
            return 0
        }
    }

}
