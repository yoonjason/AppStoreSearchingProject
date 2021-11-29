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
    let cellScale = 0.7
    var currentIndex: CGFloat = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        registerCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        layout()
    }

    func layout() {
        let screenSize = collectionView.bounds.size
        let cellWidth = screenSize.width * cellScale
        let cellHeight = screenSize.height
        let insetX = (collectionView.bounds.width - cellWidth) / 2.0
        let insetY = (collectionView.bounds.height - cellHeight) / 2.0
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = -30
        collectionView.collectionViewLayout = layout
        collectionView.decelerationRate = .fast
        
        collectionView.isPagingEnabled = false
        print("#@#==== screensize :\(screenSize), cellWidth :\(cellWidth). cellHeight : \(cellHeight), insetX: \(insetX), insetY: \(insetY)")
    }

    func registerCell() {
        collectionView.registerCell(type: IPhoneImageCell.self)
    }
}

extension DetailPreviewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iphoneImageUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: IPhoneImageCell.self, for: indexPath) as! IPhoneImageCell
        let imageUrl = iphoneImageUrls[indexPath.row]
        cell.setImage(imageUrl)
        cell.imageView.roundCorners(10)
        cell.imageView.borderColor(.lightGray)
        cell.imageView.borderWidth(0.5)
        return cell
    }

}

extension DetailPreviewCell {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let idx = round((offset.x + collectionView.contentInset.right) / cellWidth)

        if idx > currentIndex {
            currentIndex += 1
        } else if idx < currentIndex {
            if currentIndex != 0 {
                currentIndex -= 1
            }
        }

        offset = CGPoint(x: currentIndex * cellWidth - collectionView.contentInset.right, y: 0)

        targetContentOffset.pointee = offset
    }
}
