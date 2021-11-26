//
//  ScreenShotDetailViewController.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/10.
//  Copyright © 2020 yoon. All rights reserved.
//

import UIKit

class ScreenShotDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var imagesUrl = [String]()
    var data : AppData?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imagesUrl)
        setView()
    }
    
    func setView(){
        let cellWidth = screen.width - 60
        let cellHeight = screen.height - 140
        let insetX = (collectionView.bounds.width - cellWidth) / 2
        let insetY = (collectionView.bounds.height - cellHeight) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    


}
extension ScreenShotDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenShotDetailCell", for: indexPath) as? ScreenShotDetailCell
        cell?.setView(imagesUrl[indexPath.row])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screen.width - 60, height: screen.height - 140)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing

        var roundedIndex = round(index)

        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        }

        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
}
