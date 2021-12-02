//
//  WordDataManager.swift
//  AppStoreSearchingProject
//
//  Created by yoon on 2021/11/26.
//  Copyright © 2020 yoon. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class WordDataManager {
    static let shared : WordDataManager = WordDataManager()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName : String = "Words"
    
    func getWords(ascending : Bool = false) -> [Words] {
        var models = [Words]()
        
        if let context = context {
            let idSort : NSSortDescriptor = NSSortDescriptor(key: "regDate", ascending: ascending)
            let fetchRequest : NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: modelName)
            fetchRequest.sortDescriptors = [idSort]
            do {
                if let fetchResult : [Words] = try context.fetch(fetchRequest) as? [Words] {
                    models = fetchResult
                }
            }catch let error as NSError {
                print("Not fetch : \(error), \(error.userInfo)")
            }
        }
        return models
    }
    
    func saveWords(id: Int64, word : String, onSuccess : @escaping ((Bool) -> Void)) {
        if let context = context, let entity : NSEntityDescription = NSEntityDescription.entity(forEntityName: modelName, in: context) {
            if let words : Words = NSManagedObject(entity: entity, insertInto: context) as? Words {
                words.id = id
                words.word = word
                words.regDate = Date()
                contextSave { success in
                    onSuccess(success)
                }
            }
        }
    }
    
    func deleteWords(id: Int64, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: id)
        
        do {
            if let results: [Words] = try context?.fetch(fetchRequest) as? [Words] {
                if results.count != 0 {
                    context?.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("Could not fatch🥺: \(error), \(error.userInfo)")
            onSuccess(false)
        }
        
        contextSave { success in
            onSuccess(success)
        }
    }
}
extension WordDataManager {
    fileprivate func filteredRequest(id: Int64) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
            = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        return fetchRequest
    }
    
    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
        do {
            try context?.save()
            onSuccess(true)
        } catch let error as NSError {
            print("Could not save🥶: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
