//
//  Persistence.swift
//  CodeScanner
//
//  Created by Леонид Лукашевич on 16.10.2025.
//

internal import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    
    // MARK: Parameters
    
    let container: NSPersistentContainer
    
    
    // MARK: Init
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CodeScanner")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    
    // MARK: Methods
    
    func saveContext(context: NSManagedObjectContext? = nil) {
        let context = context ?? container.viewContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("CoreData save error:", error)
        }
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }
    
    
    // MARK: Preview

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        for i in 0..<10 {
            let newItem = Product(context: viewContext)
            newItem.code = "\(i)"
        }
        
        return result
    }()
}
