//
//  ViewController.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/05.
//  Copyright © 2020 yoon. All rights reserved.
//

import UIKit
import Foundation

struct RootClass : Codable {

    let resultCount : Int?
    let results : [Result]?


    enum CodingKeys: String, CodingKey {
        case resultCount = "resultCount"
        case results = "results"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try values.decodeIfPresent(Int.self, forKey: .resultCount)
        results = try values.decodeIfPresent([Result].self, forKey: .results)
    }


}


struct Result : Codable {

    let advisories : [String]?
    let appletvScreenshotUrls : [String]?
    let artistId : Int?
    let artistName : String?
    let artistViewUrl : String?
    let artworkUrl100 : String?
    let artworkUrl512 : String?
    let artworkUrl60 : String?
    let averageUserRating : Double?
    let averageUserRatingForCurrentVersion : Double?
    let bundleId : String?
    let contentAdvisoryRating : String?
    let currency : String?
    let currentVersionReleaseDate : String?
    let descriptionField : String?
    let features : [String]?
    let fileSizeBytes : String?
    let formattedPrice : String?
    let genreIds : [String]?
    let genres : [String]?
    let ipadScreenshotUrls : [String]?
    let isGameCenterEnabled : Bool?
    let isVppDeviceBasedLicensingEnabled : Bool?
    let kind : String?
    let languageCodesISO2A : [String]?
    let minimumOsVersion : String?
    let price : Float?
    let primaryGenreId : Int?
    let primaryGenreName : String?
    let releaseDate : String?
    let releaseNotes : String?
    let screenshotUrls : [String]?
    let sellerName : String?
    let sellerUrl : String?
    let supportedDevices : [String]?
    let trackCensoredName : String?
    let trackContentRating : String?
    let trackId : Int?
    let trackName : String?
    let trackViewUrl : String?
    let userRatingCount : Int?
    let userRatingCountForCurrentVersion : Int?
    let version : String?
    let wrapperType : String?


    enum CodingKeys: String, CodingKey {
        case advisories = "advisories"
        case appletvScreenshotUrls = "appletvScreenshotUrls"
        case artistId = "artistId"
        case artistName = "artistName"
        case artistViewUrl = "artistViewUrl"
        case artworkUrl100 = "artworkUrl100"
        case artworkUrl512 = "artworkUrl512"
        case artworkUrl60 = "artworkUrl60"
        case averageUserRating = "averageUserRating"
        case averageUserRatingForCurrentVersion = "averageUserRatingForCurrentVersion"
        case bundleId = "bundleId"
        case contentAdvisoryRating = "contentAdvisoryRating"
        case currency = "currency"
        case currentVersionReleaseDate = "currentVersionReleaseDate"
        case descriptionField = "description"
        case features = "features"
        case fileSizeBytes = "fileSizeBytes"
        case formattedPrice = "formattedPrice"
        case genreIds = "genreIds"
        case genres = "genres"
        case ipadScreenshotUrls = "ipadScreenshotUrls"
        case isGameCenterEnabled = "isGameCenterEnabled"
        case isVppDeviceBasedLicensingEnabled = "isVppDeviceBasedLicensingEnabled"
        case kind = "kind"
        case languageCodesISO2A = "languageCodesISO2A"
        case minimumOsVersion = "minimumOsVersion"
        case price = "price"
        case primaryGenreId = "primaryGenreId"
        case primaryGenreName = "primaryGenreName"
        case releaseDate = "releaseDate"
        case releaseNotes = "releaseNotes"
        case screenshotUrls = "screenshotUrls"
        case sellerName = "sellerName"
        case sellerUrl = "sellerUrl"
        case supportedDevices = "supportedDevices"
        case trackCensoredName = "trackCensoredName"
        case trackContentRating = "trackContentRating"
        case trackId = "trackId"
        case trackName = "trackName"
        case trackViewUrl = "trackViewUrl"
        case userRatingCount = "userRatingCount"
        case userRatingCountForCurrentVersion = "userRatingCountForCurrentVersion"
        case version = "version"
        case wrapperType = "wrapperType"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        advisories = try values.decodeIfPresent([String].self, forKey: .advisories)
        appletvScreenshotUrls = try values.decodeIfPresent([String].self, forKey: .appletvScreenshotUrls)
        artistId = try values.decodeIfPresent(Int.self, forKey: .artistId)
        artistName = try values.decodeIfPresent(String.self, forKey: .artistName)
        artistViewUrl = try values.decodeIfPresent(String.self, forKey: .artistViewUrl)
        artworkUrl100 = try values.decodeIfPresent(String.self, forKey: .artworkUrl100)
        artworkUrl512 = try values.decodeIfPresent(String.self, forKey: .artworkUrl512)
        artworkUrl60 = try values.decodeIfPresent(String.self, forKey: .artworkUrl60)
        averageUserRating = try values.decodeIfPresent(Double.self, forKey: .averageUserRating)
        averageUserRatingForCurrentVersion = try values.decodeIfPresent(Double.self, forKey: .averageUserRatingForCurrentVersion)
        bundleId = try values.decodeIfPresent(String.self, forKey: .bundleId)
        contentAdvisoryRating = try values.decodeIfPresent(String.self, forKey: .contentAdvisoryRating)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        currentVersionReleaseDate = try values.decodeIfPresent(String.self, forKey: .currentVersionReleaseDate)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        features = try values.decodeIfPresent([String].self, forKey: .features)
        fileSizeBytes = try values.decodeIfPresent(String.self, forKey: .fileSizeBytes)
        formattedPrice = try values.decodeIfPresent(String.self, forKey: .formattedPrice)
        genreIds = try values.decodeIfPresent([String].self, forKey: .genreIds)
        genres = try values.decodeIfPresent([String].self, forKey: .genres)
        ipadScreenshotUrls = try values.decodeIfPresent([String].self, forKey: .ipadScreenshotUrls)
        isGameCenterEnabled = try values.decodeIfPresent(Bool.self, forKey: .isGameCenterEnabled)
        isVppDeviceBasedLicensingEnabled = try values.decodeIfPresent(Bool.self, forKey: .isVppDeviceBasedLicensingEnabled)
        kind = try values.decodeIfPresent(String.self, forKey: .kind)
        languageCodesISO2A = try values.decodeIfPresent([String].self, forKey: .languageCodesISO2A)
        minimumOsVersion = try values.decodeIfPresent(String.self, forKey: .minimumOsVersion)
        price = try values.decodeIfPresent(Float.self, forKey: .price)
        primaryGenreId = try values.decodeIfPresent(Int.self, forKey: .primaryGenreId)
        primaryGenreName = try values.decodeIfPresent(String.self, forKey: .primaryGenreName)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        releaseNotes = try values.decodeIfPresent(String.self, forKey: .releaseNotes)
        screenshotUrls = try values.decodeIfPresent([String].self, forKey: .screenshotUrls)
        sellerName = try values.decodeIfPresent(String.self, forKey: .sellerName)
        sellerUrl = try values.decodeIfPresent(String.self, forKey: .sellerUrl)
        supportedDevices = try values.decodeIfPresent([String].self, forKey: .supportedDevices)
        trackCensoredName = try values.decodeIfPresent(String.self, forKey: .trackCensoredName)
        trackContentRating = try values.decodeIfPresent(String.self, forKey: .trackContentRating)
        trackId = try values.decodeIfPresent(Int.self, forKey: .trackId)
        trackName = try values.decodeIfPresent(String.self, forKey: .trackName)
        trackViewUrl = try values.decodeIfPresent(String.self, forKey: .trackViewUrl)
        userRatingCount = try values.decodeIfPresent(Int.self, forKey: .userRatingCount)
        userRatingCountForCurrentVersion = try values.decodeIfPresent(Int.self, forKey: .userRatingCountForCurrentVersion)
        version = try values.decodeIfPresent(String.self, forKey: .version)
        wrapperType = try values.decodeIfPresent(String.self, forKey: .wrapperType)
    }


}
let MEMBER_LIST_URL = "https://itunes.apple.com/search?country=KR&"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: MEMBER_LIST_URL + "&media=software&term=kakao&entity=software")!
        let data = try! Data(contentsOf: url)
        let json = String(data: data, encoding: .utf8)
        print(json)
    }
    //https://itunes.apple.com/search?country=KR&media=software&term=kakao&entity=software

    func fetchBookList() {
       DispatchQueue.main.async {
//          UIApplication.shared.isNetworkActivityIndicatorVisible = true
       }
       
       guard let url = URL(string: MEMBER_LIST_URL) else {
          fatalError("Invalid URL")
       }
       
       let session = URLSession.shared
       
       let task = session.dataTask(with: url) { [weak self] (data, response, error) in
          defer {
             DispatchQueue.main.async { [weak self] in
//                self?.listTableView.reloadData()
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
             }
          }
          
          if let error = error {
             print(error)
             return
          }
          
          guard let httpResponse = response as? HTTPURLResponse else {
             print("Invalid Response")
             return
          }
          
          guard (200...299).contains(httpResponse.statusCode) else {
             print(httpResponse.statusCode)
             return
          }
          
          guard let data = data else {
             fatalError("Invalid Data")
          }
          
          do {
             let decoder = JSONDecoder()
//             let bookList = try decoder.decode(BookList.self, from: data)
             
//             if bookList.code == 200 {
//                self?.list = bookList.list
//             } else {
//                self?.list = [Book]()
//             }
          } catch {
             print(error)
          }
       }
       task.resume()
    }

}

