//
//  BucketListTableViewCell.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/20/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class BucketListTableViewCell: UITableViewCell {

    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var blImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shareableLabel: UILabel!
    
    var bucketListItems: [BucketListItem]?
    var bucketList: BucketList? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        uiView.layer.shadowColor = UIColor.black.cgColor
        uiView.layer.shadowOpacity = 1
        uiView.layer.shadowOffset = .zero
        uiView.layer.shadowRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateViews() {
        guard let bucketList = bucketList, let bucketListItems = bucketListItems else { return }
        
        nameLabel.text = bucketList.name
        
//        switch bucketList.shareable {
//        case true:
//            shareableLabel.text = "Public"
//        case false:
//            shareableLabel.text = "Private"
//        }
        
        if !bucketListItems.isEmpty, let imageString = bucketListItems[0].photo, let imageURL = URL(string: imageString) {
            do {
                let image = try UIImage(withContentsOfURL: imageURL)
                blImageView.image = image
            } catch {
                NSLog("Error converting image URL: \(error)")
            }
        }
    }

}

extension UIImage {

    convenience init?(withContentsOfURL url: URL) throws {
        let imageData = try Data(contentsOf: url)
    
        self.init(data: imageData)
    }

}
