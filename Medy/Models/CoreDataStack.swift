//
//  CoreDataStack.swift
//  Medy
//
//  Created by Utku on 21/07/24.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    public lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Medy")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
