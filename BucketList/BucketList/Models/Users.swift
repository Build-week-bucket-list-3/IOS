//
//  Users.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/20/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation

public class Users: NSObject, NSCoding {
    public var users: [User] = []
    
    enum Key: String {
        case users = "users"
    }
    
    init(users: [User]) {
        self.users = users
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(users, forKey: Key.users.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        guard let decodedUsers = coder.decodeObject(forKey: Key.users.rawValue) as? [User] else {
            return nil
        }
        
        self.init(users: decodedUsers)
    }
}
