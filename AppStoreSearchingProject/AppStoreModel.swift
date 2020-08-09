//
//  AppStoreModel.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/07.
//  Copyright © 2020 yoon. All rights reserved.
//

import Foundation

struct Apps : Codable {

    let resultCount : Int?
    let results : [AppData]?


    enum CodingKeys: String, CodingKey {
        case resultCount = "resultCount"
        case results = "results"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try values.decodeIfPresent(Int.self, forKey: .resultCount)
        results = try values.decodeIfPresent([AppData].self, forKey: .results)
    }


}


struct AppData : Codable {

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


struct AppInfo : Codable {
    let seller : String?
    let fileSizeBytes : String?
    let genres : [String]?
    let minimumOsVersion : String?
    let languageCodesISO2A : [String]?
    let sellerUrl : String?
    
    enum CodingKeys: String, CodingKey {
        case seller = "seller"
        case fileSizeBytes = "fileSizeBytes"
        case genres = "genres"
        case minimumOsVersion = "minimumOsVersion"
        case languageCodesISO2A = "languageCodesISO2A"
        case sellerUrl = "sellerUrl"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        seller = try values.decodeIfPresent(String.self, forKey: .seller)
        fileSizeBytes = try values.decodeIfPresent(String.self, forKey: .fileSizeBytes)
        genres = try values.decodeIfPresent([String].self, forKey: .genres)
        minimumOsVersion = try values.decodeIfPresent(String.self, forKey: .minimumOsVersion)
        languageCodesISO2A = try values.decodeIfPresent([String].self, forKey: .languageCodesISO2A)
        sellerUrl = try values.decodeIfPresent(String.self, forKey: .sellerUrl)
    }
}

struct Review: Decodable {
  let feed: ReviewFeed
}

struct ReviewFeed: Decodable {
  let entry: [Entry]
}

struct Entry: Decodable {
  let author: Author
  let title: Label
  let content: Label
  let rating: Label
  
  private enum CodingKeys: String, CodingKey {
    case author
    case title
    case content
    case rating = "im:rating"
  }
}

struct Author: Decodable {
  let name: Label
}

struct Label: Decodable {
  let label: String
}

//struct Reviews : Codable {
//
//    let feed : Feed?
//
//
//    enum CodingKeys: String, CodingKey {
//        case feed
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        feed = try Feed(from: decoder)
//    }
//
//}
//
//struct Feed : Codable {
//
//    let author : Author?
//    let entry : [Entry]?
//    let icon : Name?
//    let id : Name?
//    let link : [ContentTypes]?
//    let rights : Name?
//    let title : Name?
//    let updated : Name?
//
//
//    enum CodingKeys: String, CodingKey {
//        case author
//        case entry = "entry"
//        case icon
//        case id
//        case link = "link"
//        case rights
//        case title
//        case updated
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        author = try Author(from: decoder)
//        entry = try values.decodeIfPresent([Entry].self, forKey: .entry)
//        icon = try Name(from: decoder)
//        id = try Name(from: decoder)
//        link = try values.decodeIfPresent([ContentTypes].self, forKey: .link)
//        rights = try Name(from: decoder)
//        title = try Name(from: decoder)
//        updated = try Name(from: decoder)
//    }
//
//
//}
//
//struct Entry : Codable {
//
//    let author : Author?
//    let content : Content?
//    let id : Name?
//    let imcontentType : ContentTypes?
//    let imrating : Name?
//    let imversion : Name?
//    let imvoteCount : Name?
//    let imvoteSum : Name?
//    let link : ContentTypes?
//    let title : Name?
//
//
//    enum CodingKeys: String, CodingKey {
//        case author
//        case content
//        case id
//        case imcontentType
//        case imrating
//        case imversion
//        case imvoteCount
//        case imvoteSum
//        case link
//        case title
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        author = try Author(from: decoder)
//        content = try Content(from: decoder)
//        id = try Name(from: decoder)
//        imcontentType = try ContentTypes(from: decoder)
//        imrating = try Name(from: decoder)
//        imversion = try Name(from: decoder)
//        imvoteCount = try Name(from: decoder)
//        imvoteSum = try Name(from: decoder)
//        link = try ContentTypes(from: decoder)
//        title = try Name(from: decoder)
//    }
//
//
//}
//struct ContentTypes : Codable {
//
//    let attributes : Attribute?
//
//
//    enum CodingKeys: String, CodingKey {
//        case attributes
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        attributes = try Attribute(from: decoder)
//    }
//}
//
//struct Content : Codable {
//
//    let attributes : Attribute?
//    let label : String?
//
//
//    enum CodingKeys: String, CodingKey {
//        case attributes
//        case label = "label"
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        attributes = try Attribute(from: decoder)
//        label = try values.decodeIfPresent(String.self, forKey: .label)
//    }
//
//
//
//}
//
//struct Attribute : Codable {
//
//    let type : String?
//    let label : String?
//    let term : String?
//    let href : String?
//    let rel : String?
//
//
//    enum CodingKeys: String, CodingKey {
//        case type = "type"
//        case label = "label"
//        case term = "term"
//        case href = "href"
//        case rel = "rel"
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        type = try values.decodeIfPresent(String.self, forKey: .type)
//        label = try values.decodeIfPresent(String.self, forKey: .label)
//        term = try values.decodeIfPresent(String.self, forKey: .term)
//        href = try values.decodeIfPresent(String.self, forKey: .href)
//        rel = try values.decodeIfPresent(String.self, forKey: .rel)
//    }
//
//
//}
//struct Author : Codable {
//
//    let name : Name?
//    let uri : Name?
//    let label : String?
//
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case uri
//        case label = "label"
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        name = try Name(from: decoder)
//        uri = try Name(from: decoder)
//        label = try values.decodeIfPresent(String.self, forKey: .label)
//    }
//
//
//}
//
//
//struct Name : Codable {
//
//    let label : String?
//
//
//    enum CodingKeys: String, CodingKey {
//        case label = "label"
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        label = try values.decodeIfPresent(String.self, forKey: .label)
//    }
//
//
//}
