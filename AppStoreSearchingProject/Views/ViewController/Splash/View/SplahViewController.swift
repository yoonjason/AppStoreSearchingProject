//
//  SplahViewController.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/27.
//  Copyright © 2021 yoon. All rights reserved.
//

import UIKit

class SplahViewController: UIViewController {
    
    var coordinator: SplashCoordinator!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self]
            self.indicator.stopAnimating()
            self.coordinator.moveToMain(with: nil)
        }
        
    }

}
