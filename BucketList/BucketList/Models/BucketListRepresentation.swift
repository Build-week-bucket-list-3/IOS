//
//  BucketListRepresentation.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/19/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation

struct BucketListRepresentation: Codable {
    let id: Int32
    let name: String
    let createdBy: User?
    let items: BucketListItems
    let shareable: Bool
    let sharedWith: Users?
    
    private enum CodingKeys: String, CodingKey {
        case id = "bucketlistId"
        case name = "bucketlistName"
        case createdBy
        case items = "entries"
        case shareable
        case sharedWith
    }
}
