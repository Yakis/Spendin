//
//  SpendingsListView.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import CoreData

struct SpendingsListView: View {
    
    @EnvironmentObject var spendingVM: SpendingVM
    @Binding var showModal: Bool
    @Binding var isUpdate: Bool
    @State private var yPos: CGFloat = 0
    @State private var height: CGFloat = 0
    @State private var size: CGSize = .zero
    
    var body: some View {
        List {
            ForEach(spendingVM.items, id: \.id) { item in
                SpendingsListCell(item: item, isUpdate: $isUpdate, showModal: $showModal)
                    .environmentObject(spendingVM)
            }
            .onDelete {
                delete(item: spendingVM.items[$0.first!])
            }
            .listRowBackground(AdaptColors.cellBackground)
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    
    private func delete(item: Item) {
        let moc = PersistenceManager.persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<CDItem>
        fetchRequest = CDItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id)
        let itemsToDelete = try! moc.fetch(fetchRequest)
        for item in itemsToDelete {
            moc.delete(item)
            do {
                try moc.saveIfNeeded()
                spendingVM.fetchItems()
            } catch {
                print(error)
            }
        }
    }
    
    private func getInterval(from startDate: Date, to endDate: Date) -> Int {
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.startOfDay(for: endDate)
        let diff = Calendar.current.dateComponents([.day], from: start, to: end)
        return diff.day!
    }
    
    
    private func calculateDuePosition(proxy: GeometryProxy) {
        size = proxy.size
        let dueElements = spendingVM.items.filter { getInterval(from: $0.date, to: Date()) == .zero }.map { $0.id }
        let indexes = dueElements.map { id in spendingVM.items.firstIndex(where: { $0.id == id }) }
        guard !indexes.isEmpty else { return }
        height = CGFloat(67) * CGFloat(indexes.count)
        yPos = CGFloat(67) * CGFloat(indexes.first!!) + (height / 2)
        print(size)
    }
    
    
}



struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}



struct DueIndicatorView: View {
    
    var height: CGFloat
    var yPos: CGFloat
    @Binding var size: CGSize
    
    var body: some View {
        VStack(alignment: .leading) {
        HStack {
            Text("Due").font(.caption2)
                .frame(alignment: .leading)
                .padding(6)
                .background(.red)
                .foregroundColor(AdaptColors.container)
                .clipShape(Circle())
                .offset(x: -3.5)
            Spacer()
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .position(x: (size.width / 2) + 7, y: yPos)
    }
    }
}
