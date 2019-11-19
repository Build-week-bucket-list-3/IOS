//
//  BucketListItems.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/19/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation

public class BucketListItems: NSObject, NSCoding {
    
    var items: [BucketListItem]
    
    enum Key: String {
        case items = "items"
    }
    
    init(items: [BucketListItem]) {
        self.items = items
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(items, forKey: Key.items.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let decodedItem = coder.decodeObject(forKey: Key.items.rawValue) as! [BucketListItem]
        
        self.init(items: decodedItem)
    }
    
    
    
}
