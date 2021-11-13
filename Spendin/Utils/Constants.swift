//
//  Constants.swift
//  Spendtrack
//
//  Created by Mugurel Moscaliuc on 11/07/2020.
//

import SwiftUI


struct AdaptColors {
    static let theOrange = Color.init("The Orange")
    static let container = Color.init("Container")
    static let fieldContainer = Color.init("FieldContainer")
    static let cellBackground = Color.init("CellBackground")
    static let categoryIcon = Color.init("CategoryIcon")
    static let adaptText = Color.init("Adapt Text")
}


enum ContextSaveContextualInfo: String {
    case addPost = "adding a post"
    case deletePost = "deleting a post"
    case batchAddPosts = "adding a batch of post"
    case deduplicate = "deduplicating tags"
    case updatePost = "saving post details"
    case addTag = "adding a tag"
    case deleteTag = "deleting a tag"
    case addAttachment = "adding an attachment"
    case deleteAttachment = "deleting an attachment"
    case saveFullImage = "saving a full image"
}
