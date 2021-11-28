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

protocol TableCellProtocol: class {
    func pageMove() -> Void
    func showCell(index: Int) -> Void
}

extension DetailViewController: TableCellProtocol {
    func pageMove() {
        performSegue(withIdentifier: "FromMainToScreenShotDetail", sender: data)
    }
    func showCell(index: Int) {
        print(index)
    }
}

class DetailViewController: UIViewController, UIScrollViewDelegate {

    var coordinator: DetailCoordinator?
    var data: AppData?
    var expandedIdxSet: IndexSet = []
    var appId: Int = 0
    var entry: [Entry] = [Entry]()
    var didSelect: (String) -> Void = { _ in }

    var detailModel: [DetailTypeModels] = [DetailTypeModels]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        registerCell()

        detailModel.append(.info)
        detailModel.append(.newFeature)
        detailModel.append(.preview)
        detailModel.append(.description)

    }

    func setView() {
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.largeTitleDisplayMode = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 280.0
    }

    func registerCell() {
        tableView.registerCell(type: DetailAppInfoCell.self)
        tableView.registerCell(type: DetailNewFeatureCell.self)
        tableView.registerCell(type: DetailPreviewCell.self)
        tableView.registerCell(type: DeatilDescriptionCell.self)
        tableView.registerCell(type: DetailInfoCell.self)
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

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailModel.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        let cellType = detailModel[indexPath.row]
        guard let data = data else { return UITableViewCell() }
        switch cellType {
        case .info:
            let customCell = self.tableView.dequeueCell(withType: DetailAppInfoCell.self) as! DetailAppInfoCell
            customCell.setView(data: data)
            cell = customCell
        case .newFeature:
            let customCell = self.tableView.dequeueCell(withType: DetailNewFeatureCell.self) as! DetailNewFeatureCell
            customCell.setData(data)
            if expandedIdxSet.contains(indexPath.row) {
                customCell.descriptionLabel.numberOfLines = 0
                customCell.moreLabel.isHidden = true
            }else {
                customCell.descriptionLabel.numberOfLines = 2
            }
            cell = customCell
        case .preview:
            let customCell = self.tableView.dequeueCell(withType: DetailPreviewCell.self) as! DetailPreviewCell
            
            cell = customCell
        case .description:
            let customCell = self.tableView.dequeueCell(withType: DeatilDescriptionCell.self) as! DeatilDescriptionCell
            customCell.setData(data)
            if expandedIdxSet.contains(indexPath.row) {
                customCell.descriptionLabel.numberOfLines = 0
                customCell.moreLabel.isHidden = true
            }else {
                customCell.descriptionLabel.numberOfLines = 2
            }
            customCell.tapped = {
                print("developer")
            }
            cell = customCell
        case .infomation:
            let customCell = self.tableView.dequeueCell(withType: DetailInfoCell.self) as! DetailInfoCell
            
            cell = customCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = detailModel[indexPath.row]
        switch cellType {
        case .info:
            return 230
        case .preview :
            return 500
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let cellType = detailModel[indexPath.row]
        switch cellType {
        case .newFeature:
            tableView.deselectRow(at: indexPath, animated: false)

            if(expandedIdxSet.contains(indexPath.row)) {
                expandedIdxSet.remove(indexPath.row)
            } else {
                expandedIdxSet.insert(indexPath.row)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .description:
            if(expandedIdxSet.contains(indexPath.row)) {
                expandedIdxSet.remove(indexPath.row)
            } else {
                expandedIdxSet.insert(indexPath.row)
            }

            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }

}

//extension DetailViewController : UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 6
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.row {
//        case 0:
//            let cell  = tableView.dequeueReusableCell(withIdentifier: "AppDetailTopInfoCell", for: indexPath) as! AppDetailTopInfoCell
//            cell.setView(data: data!)
//            cell.selectionStyle = .none
//            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "NewFeatureInfoCell", for: indexPath) as! NewFeatureInfoCell
//            cell.setData(data!)
//            if cell.delegate == nil {
//                cell.delegate = self
//            }
//            if expandedIdxSet.contains(1) {
//                cell.descLabel.numberOfLines = 0
//            } else {
//                cell.descLabel.numberOfLines = 2
//            }
//            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "PreViewTableViewCell", for: indexPath) as! PreViewTableViewCell
//            cell.setData(data!)
//            if cell.delegate == nil {
//                cell.delegate = self
//            }
//            cell.selectionStyle = .none
//            return cell
//        case 3:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AppDescriptionCell", for: indexPath) as! AppDescriptionCell
//            cell.setData(data!)
//            if expandedIdxSet.contains(3) {
//                cell.descriptionLabel.numberOfLines = 0
//            } else {
//                cell.descriptionLabel.numberOfLines = 2
//            }
//            cell.selectionStyle = .none
//            return cell
//        case 4:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AppReviewCell", for: indexPath) as! AppReviewCell
//
//            cell.setData(appId)
//            cell.selectionStyle = .none
//            if entry.count < 1 {
//                cell.isHidden = true
//            }
//
//            return cell
//        case 5:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AppInfomationCell", for: indexPath) as! AppInfomationCell
//            cell.setData(data!)
//            cell.selectionStyle = .none
//            return cell
//        default:
//            return UITableViewCell()
//        }
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if indexPath.row == 1{
//            tableView.deselectRow(at: indexPath, animated: false)
//
//            if(expandedIdxSet.contains(indexPath.row)){
//                expandedIdxSet.remove(indexPath.row)
//            } else {
//                expandedIdxSet.insert(indexPath.row)
//            }
//
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
//        else if indexPath.row == 2 {
//            print("SELECT")
//            performSegue(withIdentifier: "FromMainToScreenShotDetail", sender: nil)
//        }
//        else if indexPath.row == 3 {
//            tableView.deselectRow(at: indexPath, animated: false)
//
//            if(expandedIdxSet.contains(indexPath.row)){
//                expandedIdxSet.remove(indexPath.row)
//            } else {
//                expandedIdxSet.insert(indexPath.row)
//            }
//
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 0:
//            return 230
//        case 1:
//            return UITableView.automaticDimension
//        case 2:
//            return 534
//        case 3:
//            return UITableView.automaticDimension
//        case 4:
//            if entry.count < 1 {
//                return 0
//            }
//            return 282
//        case 5:
//            return 251
//        default:
//            return 0
//        }
//    }
//
//}
