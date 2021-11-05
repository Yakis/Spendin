//
//  ItemStorage.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import UIKit
import CoreData


class PersistenceManager {
  static let persistentContainer: NSPersistentCloudKitContainer = {
      let container = NSPersistentCloudKitContainer(name: "Spendin")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()
    
    
    
    init() {
        let center = NotificationCenter.default
        let notification = UIApplication.willResignActiveNotification

        center.addObserver(forName: notification, object: nil, queue: nil) { _ in
//          guard let self = self else { return }
            do {
            try PersistenceManager.persistentContainer.viewContext.saveIfNeeded()
            } catch {
                print("Error saving data: \(error)")
            }
        }
      }
    
    
}


class ItemStorage: NSObject, ObservableObject {
  @Published var sortedItems: [Item] = []
  private let sortedItemsController: NSFetchedResultsController<Item>

  init(managedObjectContext: NSManagedObjectContext) {
    sortedItemsController = NSFetchedResultsController(fetchRequest: Item.sortedFetchRequest,
    managedObjectContext: managedObjectContext,
    sectionNameKeyPath: nil, cacheName: nil)

    super.init()

    sortedItemsController.delegate = self

    do {
      try sortedItemsController.performFetch()
      sortedItems = sortedItemsController.fetchedObjects ?? []
    } catch {
      print("failed to fetch items!")
    }
  }
}

extension ItemStorage: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard let items = controller.fetchedObjects as? [Item] else { return }
    sortedItems = items
  }
}



extension NSManagedObjectContext {
    @discardableResult public func saveIfNeeded() throws -> Bool {
        guard hasChanges else { return false }
        try save()
        return true
    }
}
