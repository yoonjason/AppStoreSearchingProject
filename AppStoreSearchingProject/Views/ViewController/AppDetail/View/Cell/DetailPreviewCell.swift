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
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        registerCell()
        print("ASDFASDFASDFAS?")
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
        let cellScale = 0.8
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = screenSize.width * cellScale
        let cellHeight = screenSize.height * cellScale
        let insetX = (collectionView.bounds.width - cellWidth) / 2.0
        let insetY = (collectionView.bounds.height - cellHeight) / 2.0
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight )
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: 0, bottom: insetY, right: 0)
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
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 225, height: 449)
//    }

}

//extension DetailPreviewCell: UICollectionViewFlowLayout{
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        // Page width used for estimating and calculating paging.
//        let pageWidth = itemSize.width + minimumLineSpacing
//
//        // Make an estimation of the current page position.
//        let approximatePage = collectionView!.contentOffset.x/pageWidth
//
//        // Determine the current page based on velocity.
//        let currentPage = (velocity.x < 0.0) ? floor(approximatePage) : ceil(approximatePage)
//
//        // Create custom flickVelocity.
//        let flickVelocity = velocity.x * 0.3
//
//        // Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
//        let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)
//
//        // Calculate newHorizontalOffset.
//        let newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - self.collectionView!.contentInset.left
//
//        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
//    }
//}
