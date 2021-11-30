//
//  SearchResultCell.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit
import Cosmos

class SearchResultCell: UITableViewCell {

    var tapped: () -> Void = { }
    var imageUrls: [String]?
    var genreName: String = ""

    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var userCountingLabel: UILabel!
    @IBOutlet weak var getBtn: UIButton!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func onActionGet(_ sender: Any) {
        tapped()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        registerCell()
    }

    override func prepareForReuse() {
        appImageView.image = nil
        titleLabel.text = nil
        descLabel.text = nil
        userCountingLabel.text = nil
    }

    func setupViews() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let estimatedHeight = CGFloat(self.collectionView.frame.size.height)
        let estimatedWidth = CGFloat(screenWidth / 3.3)

        let layoutSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth), heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.interGroupSpacing = 5
        section.orthogonalScrollingBehavior = .groupPaging
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
        
    }

    func registerCell() {
        collectionView.registerCell(type: SearchResultImageCell.self)
    }

    func setData(appData: AppData) {

        self.appImageView.setImage(appData.artworkUrl100!)
        if let title = appData.trackName {
            titleLabel.text = title
        }

        if let genres = appData.genres {
            descLabel.text = genres[0]
        }
        if let rating = appData.averageUserRating {
            rateView.rating = rating
        }
        if let userCounting = appData.userRatingCountForCurrentVersion {
            userCountingLabel.changeUserCount(count: userCounting, detail: false)
        }

        if let imageUrls = appData.screenshotUrls {
            self.imageUrls = imageUrls
            collectionView.reloadData()
        }
        if let genrename = appData.primaryGenreName {
            self.genreName = genrename
        }
        setupViews()
    }

}

extension SearchResultCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if genreName.hasPrefix("Game") {
            return 1
        }
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueCell(withType: SearchResultImageCell.self, for: indexPath) as! SearchResultImageCell

        guard let imageUrl = self.imageUrls?[indexPath.row] else { return UICollectionViewCell() }
        cell.setImage(imageUrl)
        return cell
    }


}
