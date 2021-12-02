//
//  DetailViewController.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/26.
//  Copyright © 2020 yoon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {

    var coordinator: AppDetailCoordinator?
    var data: AppData?
    var expandedIdxSet: IndexSet = []
    var appId: Int = 0
    var entriesModel: [Entry] = [Entry]()
    var detailModel: [DetailTypeModels] = [DetailTypeModels]()

    private lazy var appIconView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        guard let imageUrl = data?.artworkUrl100 else  { return UIImageView() }
        imageView.setImage(imageUrl)
        return imageView
    }()
    
    private lazy var firstCell = tableView.subviews.first?.frame

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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

    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.largeTitleDisplayMode = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 510
        navigationItem.titleView = appIconView
        appIconView.roundCorners(10)
        appIconView.isHidden = true
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
        Task {
            do {
                let review = try await NetworkManager.shared.fetchReview(with: NetworkURLEndpoint.review.rawValue, appId: appId)
                guard let entries = review.feed?.entry else { return }
                self.entriesModel = entries
            } catch {
                print("Request feiled with error: \(error)")
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
            customCell.collectionView.layoutIfNeeded()
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
                guard let developer = data.sellerName else { return }
                self.coordinator?.developer(developer)
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
            customCell.setEntries(self.entriesModel, averageUserRating: data.averageUserRating)
            customCell.tapped = { index in
                let entry = self.entriesModel[index]
                self.coordinator?.reviewDetail([entry])
            }
            cell = customCell
        }
        cell.selectionStyle = .none
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

extension DetailViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) { [self] in
            if offsetY > firstCell?.size.height ?? 0.0 {
                appIconView.isHidden = false
            }else {
                appIconView.isHidden = true
            }
            
        } completion: { _ in
            
        }

    }
}
