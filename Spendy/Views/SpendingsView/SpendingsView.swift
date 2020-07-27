//
//  SpendingsView.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 10/07/2020.
//

import SwiftUI
import Combine

enum ItemType: String, CaseIterable {
    case expense, income
}


extension Date {
    
    func shortString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_UK")
        return dateFormatter.string(from: self)
    }
    
}


struct SpendingsView: View {
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)])
    var items: FetchedResults<Item>
    @EnvironmentObject var viewModel: SpendingVM
    @Environment(\.managedObjectContext) var moc
    @State var showModal: Bool = false
    @State private var error: String = ""
    @State private var showError: Bool = false
    @State private var getItemsCancellable: AnyCancellable?
    
    var body: some View {
        ZStack {
        VStack(alignment: .leading, spacing: 20) {
            SpendingsListView(items: viewModel.cloudItems/*items: items.sorted(by: { $0.date < $1.date })*/).environmentObject(viewModel)
            HStack {
                Text("Total: \(String(format: "%.2f", viewModel.total))")
                    .font(.custom("HelveticaNeue-Bold", size: 24))
                    .padding([.leading, .bottom], 20)
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60, alignment: .center)
                    .foregroundColor(AdaptColors.theOrange)
                    .shadow(radius: 2)
                    .transition(.scale)
                    .padding([.trailing, .bottom], 20)
                    .onTapGesture {
                        showModal.toggle()
                    }
                    .sheet(isPresented: $showModal) {
                        AddSpenderView().environmentObject(viewModel).environment(\.managedObjectContext, moc)
                    }
            }
            .alert(isPresented: $showError) {
                        Alert(title: Text("Error"), message: Text(error), dismissButton: .default(Text("Ok")))
                    }
        }.background(AdaptColors.container)
            ProgressView("Syncing...").opacity(viewModel.isSyncing ? 1 : 0)
        }
        .onAppear {
           syncWithCloud()
        }
    }
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = UIColor.init(named: "Container")
        UITableView.appearance().backgroundColor = UIColor.init(named: "Container")
    }
    
    func syncWithCloud() {
        if viewModel.localItems.isEmpty {
            getItemsCancellable = viewModel.$cloudItems
                .eraseToAnyPublisher()
                .sink { (spenders) in
//                    for spender in spenders {
//                    viewModel.saveLocaly(spender: spender, moc: moc)
//                    }
                }
            viewModel.getItemsFromServer()
        }
    }
    
    
}



struct SpendingsListView: View {
    
    @EnvironmentObject var viewModel: SpendingVM
    @Environment(\.managedObjectContext) var moc
    var items: [Spender]
    
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                HStack(spacing: 20) {
                    Label("", systemImage: item.category).font(.largeTitle)
                        .foregroundColor(item.type == "expense" ? .red : .green)
                    VStack(alignment: .leading) {
                        Text("\(item.name)")
                            .font(.custom("HelveticaNeue-Bold", size: 20))
                        Text(item.date)
                            .font(.custom("HelveticaNeue-Light", size: 14))
                    }
                    Spacer()
                    Text(amountString(item: item))
                        .font(.custom("HelveticaNeue-Bold", size: 20))
                    Spacer().frame(width: 20, height: 80, alignment: .leading)
                }
                .frame(width: UIScreen.main.bounds.width, height: 80, alignment: .leading)
                .shadow(radius: 2)
            }.onDelete {
                delete(indexSet: $0)
            }
            .listRowBackground(AdaptColors.container)
        }
    }
    
    
    private func delete(indexSet: IndexSet) {
//        do {
//            guard let index = indexSet.first else { return }
//            moc.delete(items[index])
//            try moc.save()
//            viewModel.calculateSpendings()
//        } catch {
//            print("Deleting item error: \(error.localizedDescription)")
//        }
        
    }
    
    
    private func amountString(item: Spender) -> String {
        switch item.type {
        case "expense": return "- £ \(String(format: "%.2f", item.amount))"
        default: return "+ £ \(String(format: "%.2f", item.amount))"
        }
    }
    
    
}



struct SpendingsView_Previews: PreviewProvider {
    static var previews: some View {
        SpendingsView()
    }
}
