//
//  User.swift
//  BucketList
//
//  Created by Dennis Rudolph on 11/19/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation

struct User: Codable {
    let username: String
    var password: String
    var email: String?
    var id: Int32?
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case email
        case id
    }
    
//    init(username: String, password: String, email: String? = "") {
//        self.username = username
//        self.password = password
//        self.email = email
//    }
//
//    public override init() {
//        super.init()
//    }
//
//    public func encode(with coder: NSCoder) {
//        coder.encode(username, forKey: Key.username.rawValue)
//        coder.encode(password, forKey: Key.password.rawValue)
//        coder.encode(email, forKey: Key.email.rawValue)
//    }
//
//    public required convenience init?(coder: NSCoder) {
//        guard let decodedUsername = coder.decodeObject(forKey: Key.username.rawValue) as? String,
//            let decodedPassword = coder.decodeObject(forKey: Key.password.rawValue) as? String,
//            let decodedEmail = coder.decodeObject(forKey: Key.email.rawValue) as? String? else {
//                return nil
//        }
//
//        self.init(username: decodedUsername, password: decodedPassword, email: decodedEmail)
//    }
}
//
//struct LoginUser: Codable {
//    let username: String
//    let password: String
//}
