//
//  ItemCell.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/07.
//  Copyright © 2020 yoon. All rights reserved.
//

import Foundation
import UIKit

class TableViewCell : UITableViewCell {
    
    @IBOutlet weak var titleBtn: UIButton!
    
    @IBAction func onActionTitle(_ sender: Any) {
    }
    override func prepareForReuse() {
        
    }
    
    
}
 
class SearchResultCell : UITableViewCell {
    
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setData(appData : AppList) {
        
        let url = URL(string: appData.artworkUrl60!)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.appImageView.image = UIImage(data: data!)
            }
        }
        if let title = appData.trackName {
            titleLabel.text = title
        }
        
        
       
        
    }
    
    
}
