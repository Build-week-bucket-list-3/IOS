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
    @IBOutlet weak var sharedStatusLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    func updateViews() {
        
        guard let item = item else { return }
        
        itemLabel.text = item.name
        
        if item.shareable {
            sharedStatusLabel.text = "Public"
        } else {
            sharedStatusLabel.text = "Private"
        }
        
        if item.photos[0].url != nil {
            let data = try? Data(contentsOf: item.photos[0].url!)
            self.photoImageView.image = UIImage(data: data!)
        }
    }
}
