//
//  BucketListRepresentation.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/19/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation

struct BucketListRepresentation: Codable {
    let id: Int32?
    let name: String
    let createdBy: String?
    let userID: Int32
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case createdBy = "created_by"
        case userID = "user_id"
    }
}
