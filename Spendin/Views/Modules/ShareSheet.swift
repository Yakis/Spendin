//
//  ShareSheet.swift
//  Spendin
//
//  Created by Mugurel Moscaliuc on 21/07/2022.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Invalid url"
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        guard let title = activityItems.first as? String else { return "" }
        guard let url = activityItems.last as? URL else { return "" }
        return title + "\n" + url.absoluteString
    }
    
    
}
