//
//  Extensions.swift
//  Spendy
//
//  Created by Mugurel on 09/10/2020.
//

import SwiftUI
import CoreData


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


extension Notification.Name {
    static let authDidChange = Notification.Name.init("authDidChange")
}


extension DateFormatter {
    
    static let reussableFormatter = DateFormatter()
    
}


extension Date {
    
    func shortString() -> String {
        let dateFormatter = DateFormatter.reussableFormatter
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_UK")
        return dateFormatter.string(from: self)
    }
    
    func monthName() -> String {
        let dateFormatter = DateFormatter.reussableFormatter
        dateFormatter.locale = Locale(identifier: "en_UK")
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    
    func isToday() -> Bool {
        let start = Calendar.current.startOfDay(for: self)
        let end = Calendar.current.startOfDay(for: Date())
        let diff = Calendar.current.dateComponents([.day], from: start, to: end)
        return diff.day! == .zero
    }
    
    func isPast() -> Bool {
        let start = Calendar.current.startOfDay(for: self)
        let end = Calendar.current.startOfDay(for: Date())
        let diff = Calendar.current.dateComponents([.day], from: start, to: end)
        return diff.day! > .zero
    }
    
    
}



extension String {
    
    func isoToDate() -> Date {
        if let date = DateFormatter.isoDateFormatter.date(from: self) {
            return date
        } else {
            return Date()
        }
    }
    
}


extension DateFormatter {
    
    // This gains a lot of performance, as you don't create it every time, just reuse it, and DateFormatter is expensive!!!
    static let isoDateFormatter: ISO8601DateFormatter = {
        let isoFormater = ISO8601DateFormatter()
        return isoFormater
    }()
    
    
    static let relativeFormatter: RelativeDateTimeFormatter = {
        let dateFormatter = RelativeDateTimeFormatter()
        dateFormatter.unitsStyle = .full
        return dateFormatter
    }()
    
    static let standardFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    
}
