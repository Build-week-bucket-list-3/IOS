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
        
        guard let name = name else { return nil}
       
        let bucketList = BucketListRepresentation(id: id, name: name, createdBy: createdBy, userID: userID)
        return bucketList
    }
    
    @discardableResult convenience init(id: Int32? = nil, name: String, createdBy: String?, userID: Int32, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id ?? -1
        self.name = name
        self.createdBy = createdBy
        self.userID = userID
    }
    
    @discardableResult convenience init?(bucketListRep: BucketListRepresentation, context: NSManagedObjectContext) {
        
        self.init(id: bucketListRep.id,
                  name: bucketListRep.name,
                  createdBy: bucketListRep.createdBy,
                  userID: bucketListRep.userID,
                  context: context)
    }
    
}
