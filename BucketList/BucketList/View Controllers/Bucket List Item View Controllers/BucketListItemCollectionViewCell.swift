//
//  BucketListItemCollectionViewCell.swift
//  BucketList
//
//  Created by Dennis Rudolph on 11/20/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class BucketListItemCollectionViewCell: UICollectionViewCell {
    
    var item: BucketListItem? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let demoImages: [String] = [
        "https://images.unsplash.com/photo-1574270981993-f1df213562b3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80",
        "https://images.unsplash.com/photo-1568148800034-cbca694c5c12?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
        "https://images.unsplash.com/photo-1561871733-40a3338b8cb4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=632&q=80",
        "https://images.unsplash.com/photo-1572293894491-b319f8432d77?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
        "https://images.unsplash.com/photo-1559865662-7e42f2e2fc81?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1360&q=80",
        "https://images.unsplash.com/photo-1551970353-3960cb854a2b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80"
    ]
    
    var demoIndex = Int.random(in: 0...5)
    
    
    func updateViews() {
        
        guard let item = item else { return }
        
        itemLabel.text = item.itemName
        
        if item.photo != nil {
            if let url = URL(string: item.photo!) {
                let data = try? Data(contentsOf: url)
                self.photoImageView.image = UIImage(data: data!)
            }
        } else if let imageURL = URL(string: demoImages[demoIndex]) {
            
            do {
                let image = try UIImage(withContentsOfURL: imageURL)
                photoImageView.image = image
            } catch {
                NSLog("Error converting image URL: \(error)")
            }
        }
        
        // randomly select image
        demoIndex = Int.random(in: 0...5)
    }
}

