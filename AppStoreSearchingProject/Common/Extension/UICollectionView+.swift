//
//  UICollectionView+.swift
//  wsplatform
//
//  Created by rex.kim on 2021/07/19.
//

import UIKit
extension UICollectionView {
    func updateItems( section: Int, startIndex: Int, endIndex: Int ) {
        let startRow = startIndex
        let endRow = endIndex
        var updateIndexPath: [IndexPath] = []
        for index in startRow...endRow {
            updateIndexPath.append(IndexPath(row: index, section: section))
        }
        
        self.reloadItems(at: updateIndexPath)
    }
}




public extension UICollectionView {
    
    /**
     Register nibs faster by passing the type - if for some reason the `identifier` is different then it can be passed
     - Parameter type: UITableViewCell.Type
     - Parameter identifier: String?
     */
    func registerCell(type: UICollectionViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil),
                                            forCellWithReuseIdentifier: identifier ?? cellId)
    }
    
    func registerCell(type: UICollectionReusableView.Type, forSupplementaryViewOfKind elementKind: String, identifier: String? = nil) {
        
        let cellId = String(describing: type)
        if let _ = Bundle.main.path(forResource: cellId, ofType: "nib") {
            register(UINib.init(nibName: cellId, bundle: nil),
                     forSupplementaryViewOfKind: elementKind,
                     withReuseIdentifier: cellId)
        }
        else {
            register(type,
                     forSupplementaryViewOfKind: elementKind,
                     withReuseIdentifier: cellId)
        }
    }
    
    
    func dequeueCell<T: UICollectionReusableView>(ofKind elementKind: String, withType type: UICollectionReusableView.Type, for indexPath: IndexPath) -> T? {
        
        let cellId = String(describing: type)
        return dequeueReusableSupplementaryView(ofKind: elementKind,
                                                withReuseIdentifier: cellId,
                                                for: indexPath) as? T
    }
    
    
    
    /**
     DequeueCell by passing the type of UICollectionViewCell and IndexPath
     - Parameter type: UICollectionViewCell.Type
     - Parameter indexPath: IndexPath
     */
    func dequeueCell<T: UICollectionViewCell>(withType type: UICollectionViewCell.Type, for indexPath: IndexPath) -> T? {
        let cellId = String(describing: type)
        return dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? T
    }
    
}

