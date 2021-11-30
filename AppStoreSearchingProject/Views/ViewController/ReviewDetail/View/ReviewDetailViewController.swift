//
//  ReviewDetailViewController.swift
//  AppStoreSearchingProject
//
//  Created by Bradley.yoon on 2021/11/30.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit

class ReviewDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var coordinator: ReviewDetailCoordinator?
    var entries: [Entry]?
    let cellScale: CGFloat = 0.9

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCell()
    }

    func setupViews() {

        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }

    func registerCell() {
        collectionView.registerCell(type: ReviewDetailCell.self)
    }


}

extension ReviewDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let entriesModel = entries else { return 0 }
        return entriesModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: ReviewDetailCell.self, for: indexPath) as! ReviewDetailCell
        guard let entryModel = entries?[indexPath.row] else { return UICollectionViewCell() }
        cell.setData(entryModel)
        cell.contentLabel.numberOfLines = 0
        return cell
    }

}

