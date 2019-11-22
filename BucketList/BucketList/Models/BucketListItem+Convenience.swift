//
//  BucketListItem+Convenience.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/21/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

extension BucketListItem {
    
    var bucketListItemRepresentation: BucketListItemRepresentation? {
        guard let itemName = itemName, let journalEntry  = journalEntry else { return nil }
        
        let bucketListItem = BucketListItemRepresentation(id: id, itemName: itemName, journalEntry: journalEntry, photo: photo, completed: completed, bucketID: bucketID)
        return bucketListItem
    }
    
    
    @discardableResult convenience init(id: Int32?, itemName: String, journalEntry: String? = "", photo: String? = "", completed: Bool = false, bucketID: Int32, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id ?? -1
        self.itemName = itemName
        self.journalEntry = journalEntry
        self.photo = photo
        self.completed = completed
        self.bucketID = bucketID
    }
    
    @discardableResult convenience init?(bucketListItemRep: BucketListItemRepresentation, context: NSManagedObjectContext) {
        
        self.init(id: bucketListItemRep.id,
                  itemName: bucketListItemRep.itemName,
                  journalEntry: bucketListItemRep.journalEntry,
                  photo: bucketListItemRep.photo,
                  completed: bucketListItemRep.completed,
                  bucketID: bucketListItemRep.bucketID,
                  context: context)
    }
}
