//
//  BucketList+Convenience.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/19/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

extension BucketList {
    var bucketListRepresentation: BucketListRepresentation? {
        guard let createdBy = createdBy,
            let sharedWith = sharedWith,
            let name = name,
            let items = items else { return nil }
        
        var bucketListitems = BucketListItems()
        
        for i in items.items.indices {
            
            let itemID = items.items[i].id
            let itemName = items.items[i].name
            let itemShareable = items.items[i].shareable
            let itemBucketListID = items.items[i].bucketListID
            let itemJournalEntries = items.items[i].journalEntries
            let itemPhotos = items.items[i].photos
            let itemVideos = items.items[i].videos
            let itemVoiceMemos = items.items[i].voiceMemos
            
            let bucketListItem = BucketListItem(id: itemID, name: itemName, shareable: itemShareable, bucketListID: itemBucketListID, journalEntries: itemJournalEntries, photos: itemPhotos, videos: itemVideos, voiceMemos: itemVoiceMemos)
            
            bucketListitems.items.append(bucketListItem)
        }
        
        return BucketListRepresentation(id: id, name: name, createdBy: createdBy, items: bucketListitems, shareable: shareable, sharedWith: sharedWith)
    }
    
    // Need to modify User to remove errors
    @discardableResult convenience init(id: Int32, name: String, createdBy: User, items: BucketListItems, shareable: Bool, sharedWith: Users, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        self.name = name
        self.createdBy = createdBy
        self.items = items
        self.shareable = shareable
        self.sharedWith = sharedWith
    }
    
}
