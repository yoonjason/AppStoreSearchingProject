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
    var currentIndex: Int?
    var data: AppData?
    let cellScale: CGFloat = 0.8
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCell()
    }

    func setupViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellWidth = floor(screenSize.width * cellScale)
        let cellHeight = floor(collectionView.bounds.size.height)
        let insetX = (collectionView.bounds.width - cellWidth) / 2
        let insetY = (collectionView.bounds.height - cellHeight) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.isPagingEnabled = false
        print(screenSize, cellWidth, cellHeight)

        collectionView.reloadData()
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
        guard let image = imageUrls?[indexPath.row] else { return UICollectionViewCell() }
        guard let imageData = try? Data(contentsOf: URL(string: image)!) else { return UICollectionViewCell() }
        DispatchQueue.main.async {
            cell.imageView.image = UIImage(data: imageData)

        }
        return cell
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {

        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }

        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
    }

}
