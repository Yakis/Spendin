//
//  FirebaseService.swift
//  Spendy
//
//  Created by Mugurel on 30/10/2020.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift



class FirebaseService {
    
    
    
    func getItems(handler: @escaping([Item]?, Error?) -> ()) {
        let db = Firestore.firestore()
        let ref = db.collection("items").order(by: "date")
        ref.getDocuments { (snapshot, error) in
            if error != nil {
                handler(nil, error)
            } else {
                let items = snapshot?.documents.map { Item(with: $0) }
                handler(items, nil)
            }
        }
    }
    
    
    
    func save(item: Item, handler: @escaping (Error?) -> ()) {
        let db = Firestore.firestore()
        do {
            let _ = try db.collection("items").addDocument(from: item) { error in
                handler(error)
            }
        } catch {
            handler(error)
        }
    }
    
    
    
    func update(item: Item, handler: @escaping (Error?) -> ()) {
        print(item.id)
        let db = Firestore.firestore()
        let ref = db.collection("items").document(item.id)
        ref.updateData([
            "name": item.name,
            "date": item.date,
            "amount": item.amount,
            "type": item.type,
            "category": item.category
        ]) { error in
                handler(error)
        }
    }
    
    
    func delete(item: Item, handler: @escaping(Error?) -> ()) {
        let db = Firestore.firestore()
        let ref = db.collection("items").document(item.id)
        ref.delete { (error) in
            handler(error)
        }
    }
    
    
    
}
