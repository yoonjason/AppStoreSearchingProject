//
//  ScreenShotDetailViewController.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/10.
//  Copyright © 2020 yoon. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var coordinator: ImagePreviewCoordinator?
    var imageUrls: [String]?
    var currentImageIndex: Int?
    var data: AppData?
    let cellScale: CGFloat = 0.8
    var currentIndex: CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCell()

    }

    func setupViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellWidth = floor(screenSize.width * cellScale)
        let cellHeight = floor(screenSize.height * cellScale)
        let insetX = (collectionView.bounds.width - cellWidth) / 2
        let insetY = (collectionView.bounds.height - cellHeight) / 2
        print("insetX \(insetX)")
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        collectionView.collectionViewLayout = layout
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.isPagingEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.layoutIfNeeded()
            self.collectionView.setContentOffset(CGPoint(x: CGFloat(self.currentImageIndex ?? 0) * (cellWidth + insetX/2), y: 0), animated: false)
        }
    }

    func registerCell() {
        collectionView.registerCell(type: ImagePreviewCell.self)
    }

    @IBAction func didTapComplete(_ sender: Any) {
        coordinator?.dismiss()
    }

}
extension ImagePreviewViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: ImagePreviewCell.self, for: indexPath) as! ImagePreviewCell
        guard let imageUrl = imageUrls?[indexPath.row] else { return UICollectionViewCell() }
        cell.setImage(imageUrl)

        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let idx = round((offset.x + collectionView.contentInset.left) / cellWidth)

        if idx > currentIndex {
            currentIndex += 1
        } else if idx < currentIndex {
            if currentIndex != 0 {
                currentIndex -= 1
            }
        }

        offset = CGPoint(x: currentIndex * cellWidth + collectionView.contentInset.left, y: 0)

        targetContentOffset.pointee = offset
    }
}
