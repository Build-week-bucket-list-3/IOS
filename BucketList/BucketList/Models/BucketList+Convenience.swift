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
        guard let createdBy = createdBy as? User,
            let sharedWith = sharedWith as? [User],
            let name = name,
            let items = items else { return nil }
        
        var bucketListitems: [BucketListItemRepresentation] = []
        
        for i in items.items.indices {
            
            let itemID = items.items[i].id
            let itemBucketListID = items.items[i].bucketListID
            let itemJournalEntries = items.items[i].journalEntries
            let itemPhotos = items.items[i].photos
            let itemVideos = items.items[i].videos
            let itemVoiceMemos = items.items[i].voiceMemos
            
            var journalEntries: [JournalEntry] = []
            for j in itemJournalEntries.indices {
                let journalEntry = JournalEntry(url: itemJournalEntries[i].absoluteString)
                journalEntries.append(journalEntry)
            }
            
            var photos: [Photo] = []
            for j in itemPhotos.indices {
                let photo = Photo(url: itemPhotos[i].absoluteString)
                photos.append(photo)
            }
            
            var videos: [Video] = []
            for j in itemVideos.indices {
                let video = Video(url: itemVideos[i].absoluteString)
                videos.append(video)
            }
            
            var voiceMemos: [VoiceMemo] = []
            for j in itemVoiceMemos.indices {
                let voiceMemo = VoiceMemo(url: itemVoiceMemos[i].absoluteString)
                voiceMemos.append(voiceMemo)
            }
            
            let bucketListItem = BucketListItemRepresentation(id: itemID, bucketListID: itemBucketListID, journalEntries: journalEntries, photos: photos, videos: videos, voiceMemos: voiceMemos)
            
            bucketListitems.append(bucketListItem)
        }
        
        return BucketListRepresentation(id: id, name: name, createdBy: createdBy, items: bucketListitems, shareable: shareable, sharedWith: sharedWith)
    }
    
    // Need to modify User to remove errors
    @discardableResult convenience init(id: Int32, name: String, createdBy: User, items: BucketListItems, shareable: Bool, sharedWith: [User], context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        self.name = name
        self.createdBy = createdBy
        self.items = items
        self.shareable = shareable
        self.sharedWith = sharedWith
    }
    
}
