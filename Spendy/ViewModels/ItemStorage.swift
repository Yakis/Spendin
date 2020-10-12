//
//  ItemStorage.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import UIKit
import CoreData


class PersistenceManager {
  let persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "Spendy")
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

        center.addObserver(forName: notification, object: nil, queue: nil) { [weak self] _ in
          guard let self = self else { return }

          if self.persistentContainer.viewContext.hasChanges {
            try? self.persistentContainer.viewContext.save()
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
    guard let items = controller.fetchedObjects as? [Item]
      else { return }

    sortedItems = items
  }
}
