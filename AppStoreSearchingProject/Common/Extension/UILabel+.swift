//
//  UILabel+.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/28.
//  Copyright © 2021 yoon. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

    func changeUserCount(count: Int, detail: Bool) {
        var returnValue = String(count)
        if returnValue.count == 4 {
            let range = NSMakeRange(0, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range) + "천"

        } else if returnValue.count == 5 {
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(1, 1)
            returnValue = (NSString(string: returnValue)).substring(with: range1) + "." + (NSString(string: returnValue)).substring(with: range2) + "만"
        } else if returnValue.count == 6 {
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
        if detail {
            self.text = returnValue + "개의 평가"
        }else {
            self.text = returnValue
        }
    }
    
    func getNow() -> Date {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST+9:00")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.string(from: now)

        return now
    }

    func updateTime(_ date: String) {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                       .withTime,
                                       .withDashSeparatorInDate,
                                       .withColonSeparatorInTime
        ]

        let date2 = formatter.date(from: date)
        let dateFormatter = DateFormatter()
        // Locale
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST+9:00")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
            self.text = "\(yearGap ?? 0)년 전"
        } else if monthGap! > 0 {
            self.text = "\(monthGap ?? 0)개월 전"
        }
        else if dayGap! > 0 {
            self.text = "\(dayGap ?? 0)일 전"
        } else if (dayGap == 0 && hourGap == 0) {
            self.text = "\(minGap ?? 0)분 전"
        } else if (dayGap == 0) {
            self.text = "\(hourGap ?? 0)시간 전"
        }
    }
}
