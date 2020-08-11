//
//  Words+CoreDataProperties.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2020/08/07.
//  Copyright © 2020 yoon. All rights reserved.
//
//

import Foundation
import CoreData


extension Words {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Words> {
        return NSFetchRequest<Words>(entityName: "Words")
    }

    @NSManaged public var id: Int64
    @NSManaged public var word: String?

}
