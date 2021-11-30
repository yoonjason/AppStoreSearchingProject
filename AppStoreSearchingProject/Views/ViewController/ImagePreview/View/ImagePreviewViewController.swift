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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.layoutIfNeeded()
            self.collectionView.setContentOffset(CGPoint(x: CGFloat(self.currentImageIndex ?? 0), y: 0), animated: false)
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
    
}
