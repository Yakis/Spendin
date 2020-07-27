//
//  SpendingVM.swift
//  Spendtrack
//
//  Created by Mugurel on 13/07/2020.
//

import SwiftUI
import CoreData
import Combine


struct Spender: Codable, Equatable, Hashable {
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case amount = "amount"
        case type = "type"
        case category = "category"
        case date = "date"
    }
    
    
    var id: UUID
    var name: String
    var amount: Double
    var type: String
    var category: String
    var date: String
    
    
    init(with item: Item) {
        let formatter = ISO8601DateFormatter()
        self.id = item.id
        self.name = item.name
        self.amount = item.amount
        self.type = item.type
        self.category = item.category
        self.date = formatter.string(from: item.date)
    }
    
    
    init(id: UUID, name: String, amount: Double, type: String, category: String, date: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.type = type
        self.category = category
        self.date = date
    }
    
}


class SpendingVM: ObservableObject {
    
    @AppStorage("userToken") var userToken: String = ""
    @Published var total: Double = 0
    @Published var cloudItems: [Spender] = []
    @Published var localItems: [Spender] = []
    @Published var isSyncing: Bool = false
    @Published var error: AuthError?
    
    private var cancellables = Set<AnyCancellable>()
    
    func calculateSpendings() {
        DispatchQueue.main.async {
            var temp: Double = 0
            for item in self.localItems {
                if item.type == "expense" {
                    temp -= item.amount
                } else {
                    temp += item.amount
                }
                self.total = temp
            }
        }
        
    }
    
    
    func uploadItem(spender: Spender) {
        let json = try! JSONEncoder().encode(spender)
        guard let url = URL(string: "http://127.0.0.1:8080/items") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(userToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = json
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error  in
            guard let data = data else {
                print(error!)
                return
            }
        }.resume()
            
    }
    
    
    
//    func saveLocaly(spender: Spender, moc: NSManagedObjectContext) {
//        let dateFormatter = ISO8601DateFormatter()
//        let newItem = Item(context: moc)
//        newItem.name = spender.name
//        newItem.amount = spender.amount
//        newItem.type = spender.type
//        newItem.category = spender.category
//        newItem.date = dateFormatter.date(from: spender.date)!
//        newItem.id = spender.id
//        do {
//            try moc.save()
//            localItems.append(spender)
//            uploadItem(spender: spender)
//            calculateSpendings()
//        } catch {
//            print("Core data error: \(error)")
//        }
//    }
    
    
    
    func getItemsFromServer() {
        guard let url = URL(string: "http://127.0.0.1:8080/items") else { return }
        DispatchQueue.main.async {
            self.isSyncing = true
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(userToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .map {
                let authError = try? JSONDecoder().decode(AuthError.self, from: $0)
                DispatchQueue.main.async {
                    self.error = authError
                }
                return $0
            }
            .decode(type: [Spender].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isSyncing = false
            } receiveValue: { [weak self] (spenders) in
                self?.cloudItems = spenders
                self?.isSyncing = false
            }
            .store(in: &cancellables)

    }
    
    
    
        }



struct AuthError: Codable, Error {
    var error: Bool
    var reason: String
}
