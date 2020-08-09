//
//  ItemCell.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/07.
//  Copyright © 2020 yoon. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class RecentSearchTableViewCell : UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        titleLabel.text = nil
    }
    
    func setData(_ title : String) {
        titleLabel.text = title
    }
    
    
}
 
class SearchResultCell : UITableViewCell {
    
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var userCountingLabel: UILabel!
    @IBOutlet weak var getBtn: UIButton!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBAction func onActionGet(_ sender: Any) {
    }
    
    var screenShotImageViews: [UIImageView] {
        return imageStackView.arrangedSubviews as! [UIImageView]
    }
    
    override func prepareForReuse() {
        appImageView.image = nil
        titleLabel.text = nil
        descLabel.text = nil
        userCountingLabel.text = nil
        screenShotImageViews.forEach{ imageView in
            imageView.image = nil
        }
    }
    
    func setData(appData : AppData) {
        
        let url = URL(string: appData.artworkUrl60!)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.appImageView.image = UIImage(data: data!)
            }
        }
        if let title = appData.trackName {
            titleLabel.text = title
        }

        if let genres = appData.genres {
            descLabel.text = genres[0]
        }
        if let rating = appData.averageUserRating {
            rateView.rating = rating
        }
        if let userCounting = appData.userRatingCountForCurrentVersion {
            userCountingLabel.text = changeUserCount(count: userCounting) + " ( \(userCounting.toDecimalFormat!) )"
        }
        
        if let screenShots = appData.screenshotUrls?.enumerated() {
            for (index, screenshot) in screenShots {
                if index > 2 {
                    return
                }
                DispatchQueue.global().async {
                    guard let imageData = try? Data(contentsOf: URL(string: screenshot)!) else { return }
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.screenShotImageViews[index].image = image
                    }
                    
                }
            }
        }
        
    }
    
    
    
    func changeUserCount(count : Int) -> String {
        var returnValue = String(count)
        if returnValue.count == 4 {
            let range = NSMakeRange(0, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range) + "천"
            
        }else if returnValue.count == 5 {
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(1, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range1) + "." + (NSString(string: returnValue)).substring(with: range2) + "만"
        }else if returnValue.count == 6 {
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(1, 1)
            let range3 = NSMakeRange(2, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range1) + (NSString(string: returnValue)).substring(with: range2) + "." + (NSString(string: returnValue)).substring(with: range3) + "만"
        }
        else if returnValue.count == 7 {
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(1, 1)
            let range3 = NSMakeRange(2, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range1) + (NSString(string: returnValue)).substring(with: range2) + (NSString(string: returnValue)).substring(with: range3) + "만"
        }
        return returnValue
    }
    
}


class SuggestedTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!

    func set(term: String, searchedTerm: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 21),
            .foregroundColor: UIColor(white: 0.56, alpha: 1.0)
        ]
        let attributedString = NSAttributedString(
            string: term.lowercased(),
            attributes: attributes
        )
        let mutableAttributedString = NSMutableAttributedString(
            attributedString: attributedString
        )
        mutableAttributedString.setBold(text: searchedTerm.lowercased())
        label.attributedText = mutableAttributedString
    }
}


class AppDetailTopInfoCell : UITableViewCell {
    
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var averageCountLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var userReviewCountLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var chartLabel: UILabel!
    @IBOutlet weak var downloadTopConstant: NSLayoutConstraint!
    
    func setView(data : AppData){
        //artworkUrl100
        let url = URL(string: data.artworkUrl512!)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.appImageView.image = UIImage(data: data!)
            }
        }
        if let title = data.trackName, let subTitle = data.artistName {
            titleLabel.text = title
            subTitleLabel.text = subTitle
            let width = (data.trackName! as NSString).size(withAttributes: [NSAttributedString.Key.font : titleLabel.font]).width
            if width > 230 {
                downloadTopConstant.constant = 0
            }
            
            
        }
        if let rating = data.averageUserRating {
            rateView.rating = rating
            averageCountLabel.text = "\(round(rating))"
        }
        
        
        if let age = data.trackContentRating {
            ageLabel.text = age
        }
        if let genres = data.genres {
            genreLabel.text = genres[0]
        }
        if let userCounting = data.userRatingCountForCurrentVersion {
            userReviewCountLabel.text =  changeUserCount(count: userCounting) + " 개의 평가 " + " ( \(userCounting.toDecimalFormat!) )"
        }
        
        
    }

    func changeUserCount(count : Int) -> String {
        var returnValue = String(count)
        if returnValue.count == 4 {
            let range = NSMakeRange(0, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range) + "천"
            
        }else if returnValue.count == 5 {
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(1, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range1) + "." + (NSString(string: returnValue)).substring(with: range2) + "만"
        }else if returnValue.count == 6 {
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(1, 1)
            let range3 = NSMakeRange(2, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range1) + (NSString(string: returnValue)).substring(with: range2) + "." + (NSString(string: returnValue)).substring(with: range3) + "만"
        }
        else if returnValue.count == 7 {
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(1, 1)
            let range3 = NSMakeRange(2, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range1) + (NSString(string: returnValue)).substring(with: range2) + (NSString(string: returnValue)).substring(with: range3) + "만"
        }
        return returnValue
    }
}

class NewFeatureInfoCell :  UITableViewCell {
    
    var isShow = false
    @IBOutlet weak var versionHistoryBtn: UIButton!
    @IBOutlet weak var newFeatureLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    
    
    func setData(_ data : AppData) {
        if let releaseNotes = data.releaseNotes, let date = data.currentVersionReleaseDate, let version = data.version {
//            updateDateLabel.text = date

            updateTime(date)
            versionLabel.text = version
            descLabel.text = releaseNotes
            if descLabel.text!.count < 30 {
                moreBtn.isHidden = true
            }
        }
        
    }
    
    override func prepareForReuse() {
       
    }
   
    
    func subString(orgString: String, startIndex: Int, endIndex: Int) -> String {
        let end                                            = (endIndex - orgString.count) + 1
        let indexStartOfText                               = orgString.index(orgString.startIndex, offsetBy: startIndex)
        let indexEndOfText                                 = orgString.index(orgString.endIndex, offsetBy: end)
        let substring                                      = orgString[indexStartOfText..<indexEndOfText]
        return String(substring)
    }
    
    func getNow() -> Date {
        // current day & time
        let now                                            = Date()
        // 데이터 포맷터
        let dateFormatter                                  = DateFormatter()
        // Locale
        dateFormatter.locale                               = Locale(identifier: "ko_KR")
        dateFormatter.timeZone                             = TimeZone(abbreviation: "KST+9:00")
        dateFormatter.dateFormat                           = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.string(from: now)
        
        return now
    }
    
    func updateTime(_ date : String) {
        let formatter  = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime
        ]
        
        let date2 = formatter.date(from: date)
        let dateFormatter                                  = DateFormatter()
        // Locale
        dateFormatter.locale                               = Locale(identifier: "ko_KR")
        dateFormatter.timeZone                             = TimeZone(abbreviation: "KST+9:00")
        dateFormatter.dateFormat                           = "yyyy-MM-dd HH:mm:ss"
        let endDate1 = dateFormatter.string(from: date2!)
        let endDate = dateFormatter.date(from: endDate1)
        let calendar = Calendar.current
        let dateGap = calendar.dateComponents([.year, .month, .day, .minute, .hour, .second], from: endDate!, to: getNow())
        let yearGap = dateGap.year
        let monthGap = dateGap.month
        let dayGap = dateGap.day
        let hourGap = dateGap.hour
        let minGap = dateGap.minute

        if yearGap! > 0 {
           self.updateDateLabel.text = "\(yearGap ?? 0)년 전"
        }else if monthGap! > 0 {
             self.updateDateLabel.text = "\(monthGap ?? 0)개월 전"
        }
        else if dayGap! > 0 {
            self.updateDateLabel.text = "\(dayGap ?? 0)일 전"
        }else if (dayGap == 0 && hourGap == 0) {
            self.updateDateLabel.text = "\(minGap ?? 0)분 전"
        }else if (dayGap == 0){
            self.updateDateLabel.text = "\(hourGap ?? 0)시간 전"
        }
    }
}

class PreViewTableViewCell : UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    var imageUrlStrings = [String]()
    

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setData(_ data : AppData) {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellWidth = screen.width - 100
        let cellHeight = screen.height - 100

        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)

        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        if let imageUrlStrings = data.screenshotUrls {
            self.imageUrlStrings = imageUrlStrings
        }
        print(self.imageUrlStrings.count)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageUrlStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IPhoneScreenShotCell", for: indexPath) as? IPhoneScreenShotCell
        let urlString = imageUrlStrings[indexPath.row]
        cell?.setView(urlString)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 225, height: 449)
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

class IPhoneScreenShotCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func setView(_ imageUrl:String){
        let url = URL(string: imageUrl)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
//        imageView.layer.cornerRadius = 36
    }
}

class AppDescriptionCell : UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var developerBtn: UIButton!
    @IBOutlet weak var developerLabel: UILabel!
    
    func setData(_ data: AppData) {
        if let group = data.sellerName {
            developerBtn.setTitle(group, for: .normal)
        }
        if let description = data.descriptionField {
            descriptionLabel.text = description
        }
    }
}

class AppInfomationCell : UITableViewCell, UITableViewDelegate, UITableViewDataSource {
   
    var appData : AppData?
    
    @IBOutlet weak var tableView: UITableView!
    
    func setData(_ data : AppData) {
        appData = data
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 6
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as? AppInfomationCell
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "0"
        case 1:
            cell?.textLabel?.text = "1"
        case 2:
            cell?.textLabel?.text = "2"
        case 3:
            cell?.textLabel?.text = "3"
        case 4:
            cell?.textLabel?.text = "4"
        case 5:
            cell?.textLabel?.text = "5"
        default:
            return UITableViewCell()
        }
        
        
        return cell!
       }
}

class AppInfomationDetailCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    func setData(_ data : AppData){
        
    }
}
