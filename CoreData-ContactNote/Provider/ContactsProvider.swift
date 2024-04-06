//
//  ContactProvider.swift
//  CoreData-ContactNote
//
//  Created by Đoàn Văn Khoan on 01/04/2024.
//

import Foundation
import CoreData
import SwiftUI

final class ContactsProvider {
    static let shared = ContactsProvider()
    
    private let persistantContainer : NSPersistentContainer
    
    var viewContext : NSManagedObjectContext {
        persistantContainer.viewContext
    }
    
    var newContext : NSManagedObjectContext {
        persistantContainer.newBackgroundContext()
    }
    
    private init(){
        persistantContainer = NSPersistentContainer(name: "ContactsDataModel")
        
        // Preview
        if EnvironmentValues.isPreview || Thread.current.isMainThread  {
            persistantContainer.persistentStoreDescriptions.first?.url = .init(URL(fileURLWithPath: "/dev/null"))
        }
        
        persistantContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistantContainer.loadPersistentStores{ _, error in
            if let error {
                print("Unable to load store with error \(error)")
            }
        }
    }
    
    func exists(_ contact: Contact, in context: NSManagedObjectContext) -> Contact? {
        try? context.existingObject(with: contact.objectID) as? Contact
    }
    
    func delete(_ contact: Contact, in context: NSManagedObjectContext) throws {
        if let existingContact = exists(contact, in: context) {
            context.delete(existingContact)
            
            // create a background task with lower priority
            Task(priority: .background){
                try await context.perform{
                    try context.save()
                }
            }
        }
    }
    
    func persist(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

// Fix Preview
extension EnvironmentValues {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}


// Unit Test

extension Thread {
    var isRunningXCTest: Bool {
        for key in self.threadDictionary.allKeys {
            guard let keyAsString = key as? String else { continue }
            
            if keyAsString.split(separator: ".").contains("xctest") {
                return true
            }
        }
        return false
    }
}
