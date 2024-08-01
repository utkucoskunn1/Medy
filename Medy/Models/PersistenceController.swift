//
//  PersistenceController.swift
//  Medy
//
//  Created by Utku on 21/07/24.
//

// Dosya: PersistenceController.swift

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // Örnek veri eklemek için buraya bazı veriler ekleyebilirsiniz.
        do {
            try addSampleData(to: viewContext)
        } catch {
            fatalError("Unresolved error \(error), \(error.localizedDescription)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Medy")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // Save context helper function
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // Örnek veri ekleme fonksiyonu
    static func addSampleData(to context: NSManagedObjectContext) throws {
        // Örnek veri ekleyin
        // let newEntity = Entity(context: context)
        // newEntity.attribute = value
        try context.save()
    }
}
