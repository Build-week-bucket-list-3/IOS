//
//  BucketListItem.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/19/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation

class BucketListItem: NSObject, NSCoding {
    
    public var id: Int32
    public var bucketListID: Int32
    public var journalEntries: [URL]
    public var photos: [URL]
    public var videos: [URL]
    public var voiceMemos: [URL]
    
    // var bucketListItemRepresentation:
    
    enum Key: String {
        case id = "id"
        case bucketListID = "bycket_list_ID"
        case journalEntries
        case photos
        case videos
        case voiceMemos
    }
    
    init(id: Int32, bucketListID: Int32, journalEntries: [URL], photos: [URL], videos: [URL], voiceMemos: [URL]) {
        self.id = id
        self.bucketListID = bucketListID
        self.journalEntries = journalEntries
        self.photos = photos
        self.videos = videos
        self.voiceMemos = voiceMemos
    }
    
//    public override init() {
//        super.init()
//    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: Key.id.rawValue)
        coder.encode(bucketListID, forKey: Key.bucketListID.rawValue)
        coder.encode(journalEntries, forKey: Key.journalEntries.rawValue)
        coder.encode(photos, forKey: Key.photos.rawValue)
        coder.encode(videos, forKey: Key.videos.rawValue)
        coder.encode(voiceMemos, forKey: Key.voiceMemos.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let dID = coder.decodeInt32(forKey: Key.id.rawValue)
        let dBucketListID = coder.decodeInt32(forKey: Key.bucketListID.rawValue)
        
        guard let dJournalEntries = coder.decodeObject(forKey: Key.journalEntries.rawValue) as? [URL],
            let dPhotos = coder.decodeObject(forKey: Key.photos.rawValue) as? [URL],
            let dVideos = coder.decodeObject(forKey: Key.videos.rawValue) as? [URL],
            let dVoiceMemos = coder.decodeObject(forKey: Key.voiceMemos.rawValue) as? [URL] else {
                return nil
        }
        
        self.init(id: dID, bucketListID: dBucketListID, journalEntries: dJournalEntries, photos: dPhotos, videos: dVideos, voiceMemos: dVoiceMemos)
    }
    
    
}