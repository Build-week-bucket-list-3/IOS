//
//  BucketListItem.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/19/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation

struct BucketListItem: Codable {
    
    let id: Int32
    let itemName: String
    let journalEntry: String
    let photo: String?
    let completed: Bool
    let bucketID: Int32
    
    // var bucketListItemRepresentation:
    
    enum CodingKeys: String, CodingKey {
        case id
        case itemName = "item_name"
        case journalEntry = "journal_entry"
        case photo
        case completed
        case bucketID = "bucket_id"
    }
    
    init(id: Int32, itemName: String, journalEntry: String, photo: String? = nil, completed: Bool = false, bucketID: Int32) {
        self.id = id
        self.itemName = itemName
        self.journalEntry = journalEntry
        self.photo = photo
        self.completed = completed
        self.bucketID = bucketID
    }
}
