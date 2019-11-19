//
//  BucketListItemRepresentation.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/19/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation

struct BucketListItemRepresentation: Codable {
    let id: Int32
    let bucketListID: Int32
    let journalEntries: [JournalEntry]
    let photos: [Photo]
    let videos: [Video]
    let voiceMemos: [VoiceMemo]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case bucketListID
        case journalEntries
        case photos
        case videos
        case voiceMemos
    }
}

struct JournalEntry: Codable {
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case url
    }
}

struct Photo: Codable {
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case url
    }
}

struct Video: Codable {
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case url
    }
}

struct VoiceMemo: Codable {
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case url
    }
}
