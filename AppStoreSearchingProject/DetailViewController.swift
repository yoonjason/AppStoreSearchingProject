//
//  DetailViewController.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/09.
//  Copyright © 2020 yoon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var data : AppData?
    var expandedIndexSet : IndexSet = []
    var appId : Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(data)
        // Do any additional setup after loading the view.
        setView()
    }
    
    func setView(){
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.largeTitleDisplayMode = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 280.0
    }
    

}
extension DetailViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "AppDetailTopInfoCell", for: indexPath) as! AppDetailTopInfoCell
            cell.setView(data: data!)
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewFeatureInfoCell", for: indexPath) as! NewFeatureInfoCell
            cell.setData(data!)
            if expandedIndexSet.contains(1) {
                cell.descLabel.numberOfLines = 0
            } else {
                cell.descLabel.numberOfLines = 2
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreViewTableViewCell", for: indexPath) as! PreViewTableViewCell
            cell.setData(data!)
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppDescriptionCell", for: indexPath) as! AppDescriptionCell
            cell.setData(data!)
            if expandedIndexSet.contains(3) {
                cell.descriptionLabel.numberOfLines = 0
            } else {
                cell.descriptionLabel.numberOfLines = 2
            }
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1{
            tableView.deselectRow(at: indexPath, animated: false)
            
            if(expandedIndexSet.contains(indexPath.row)){
                expandedIndexSet.remove(indexPath.row)
            } else {
                expandedIndexSet.insert(indexPath.row)
            }

            tableView.reloadRows(at: [indexPath], with: .automatic)
        }else if indexPath.row == 3 {
            tableView.deselectRow(at: indexPath, animated: false)
            
            if(expandedIndexSet.contains(indexPath.row)){
                expandedIndexSet.remove(indexPath.row)
            } else {
                expandedIndexSet.insert(indexPath.row)
            }

            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 230
        case 1:
            return UITableView.automaticDimension
        case 2:
            return 534
        case 3:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
}
