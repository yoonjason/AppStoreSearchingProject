//
//  DetailPreviewCell.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/28.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit

class DetailPreviewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var iphoneImageUrls = [String]()
    let cellScale = 0.8
    var currentIndex: CGFloat = 0.0
    var tapped: (Int) -> Void = { _ in }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        registerCell()
    }

    func setupViews() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                               heightDimension: .fractionalHeight(0.94))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = -31
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
    }


    func registerCell() {
        collectionView.registerCell(type: DetailImageCell.self)
    }
}

extension DetailPreviewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iphoneImageUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCell(withType: DetailImageCell.self, for: indexPath) as! DetailImageCell
        let imageUrl = iphoneImageUrls[indexPath.row]
        cell.setImage(imageUrl)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapped(indexPath.row)
    }

}

