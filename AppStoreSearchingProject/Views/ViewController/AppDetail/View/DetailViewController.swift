//
//  DetailViewController.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/09.
//  Copyright © 2020 yoon. All rights reserved.
//

import UIKit

protocol TableCellProtocol: class {
    func pageMove() -> Void
    func showCell(index: Int) -> Void
}

class DetailViewController: UIViewController, UIScrollViewDelegate {

    var coordinator: AppDetailCoordinator?
    var data: AppData?
    var expandedIdxSet: IndexSet = []
    var appId: Int = 0
    var entriesModel: [Entry] = [Entry]()
    var detailModel: [DetailTypeModels] = [DetailTypeModels]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        registerCell()
        setModel()
        requestReviewInfo()
    }

    func setModel() {
        detailModel.append(.info)
        detailModel.append(.newFeature)
        detailModel.append(.preview)
        detailModel.append(.description)
        detailModel.append(.review)
        detailModel.append(.infomation)
    }

    func setView() {
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.largeTitleDisplayMode = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 510
    }

    func registerCell() {
        tableView.registerCell(type: DetailAppInfoCell.self)
        tableView.registerCell(type: DetailNewFeatureCell.self)
        tableView.registerCell(type: DetailPreviewCell.self)
        tableView.registerCell(type: DeatilDescriptionCell.self)
        tableView.registerCell(type: DetailInfoCell.self)
        tableView.registerCell(type: DetailReviewCell.self)
    }

    func requestReviewInfo() {
        NetworkManager.shared.requestAppReview(NetworkURLEndpoint.review.rawValue, appId: appId) { response in
            if let resultData = try? JSONDecoder().decode(Review.self, from: response), let entries = resultData.feed?.entry {
                self.entriesModel = entries
            }
        } failure: { error in
            print(error)
            print("error #@# === \(error)")
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
            } else {
                customCell.descriptionLabel.numberOfLines = 4
            }
            cell = customCell
        case .preview:
            let customCell = self.tableView.dequeueCell(withType: DetailPreviewCell.self) as! DetailPreviewCell
            if let screenUrls = data.screenshotUrls {
                customCell.iphoneImageUrls = screenUrls
            }
            customCell.tapped = { index in
                guard let screenUrls = data.screenshotUrls else { return }
                self.coordinator?.imagePreivew(screenUrls, currentIndex: index)
            }
            customCell.collectionView.reloadData()
            cell = customCell
        case .description:
            let customCell = self.tableView.dequeueCell(withType: DeatilDescriptionCell.self) as! DeatilDescriptionCell
            customCell.setData(data)
            if expandedIdxSet.contains(indexPath.row) {
                customCell.descriptionLabel.numberOfLines = 0
                customCell.moreLabel.isHidden = true
            } else {
                customCell.descriptionLabel.numberOfLines = 4
            }
            customCell.tapped = {
                print("developer")
            }
            cell = customCell
        case .infomation:
            let customCell = self.tableView.dequeueCell(withType: DetailInfoCell.self) as! DetailInfoCell
            var row: [[String: String]] = []
            if let seller = data.sellerName {
                row.append(["제공자": seller])
            }
            if let size = data.fileSizeBytes {
                let bcf = ByteCountFormatter()
                row.append(["크기": bcf.string(fromByteCount: Int64(size) ?? 0)])
            }
            if let categories = data.genres {
                row.append(["카테고리": categories[0]])
            }
            if let version = data.minimumOsVersion {
                row.append(["버전": version])
            }
            if let age = data.trackContentRating {
                row.append(["연령 등급": age])
            }
            if let languages = data.languageCodesISO2A {
                if languages.count == 0 {
                    row.append(["언어": "한국어"])
                } else {
                    row.append(["언어": "한국어 외 \(languages.count - 1)개"])
                }
            }
            customCell.row = row

            cell = customCell
        case .review:
            let customCell = self.tableView.dequeueCell(withType: DetailReviewCell.self) as! DetailReviewCell
            customCell.setEntries(self.entriesModel)
            customCell.tapped = { index in
                let entry = self.entriesModel[index]
                self.coordinator?.reviewDetail([entry])
            }
            cell = customCell
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let cellType = detailModel[indexPath.row]
        switch cellType {
        case .newFeature:
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
        case .review:
            self.coordinator?.reviewDetail(self.entriesModel)
        default:
            break
        }
    }

}
