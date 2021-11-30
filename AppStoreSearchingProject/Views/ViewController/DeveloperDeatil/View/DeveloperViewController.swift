//
//  DeveloperViewController.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/12/01.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit

class DeveloperViewController: UIViewController {
    
    var developer: String?
    var coordinator: DeveloperCoordinator?
    
    @IBOutlet weak var developerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let developer = developer else { return }
        self.developerLabel.text = developer
    }
    

}
