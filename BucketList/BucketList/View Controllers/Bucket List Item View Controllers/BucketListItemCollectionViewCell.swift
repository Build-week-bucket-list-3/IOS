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
    
    
    func updateViews() {
        
        guard let item = item else { return }
        
        itemLabel.text = item.itemName
        
        if item.photo != nil {
            if let url = URL(string: item.photo!) {
                let data = try? Data(contentsOf: url)
                self.photoImageView.image = UIImage(data: data!)
            }
        }
    }
}
