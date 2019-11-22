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
    
    var bucketList: BucketList? {
        didSet {
            updateViews()
        }
    }
    
    let demoImages: [String] = [
        "https://images.unsplash.com/photo-1574270981993-f1df213562b3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80",
        "https://images.unsplash.com/photo-1568148800034-cbca694c5c12?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
        "https://images.unsplash.com/photo-1561871733-40a3338b8cb4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=632&q=80",
        "https://images.unsplash.com/photo-1572293894491-b319f8432d77?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
        "https://images.unsplash.com/photo-1559865662-7e42f2e2fc81?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1360&q=80",
        "https://images.unsplash.com/photo-1551970353-3960cb854a2b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80"
    ]
    
    var demoIndex = 0
    
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
        guard let bucketList = bucketList else { return }
        
        nameLabel.text = bucketList.name
        
        if let imageURL = URL(string: demoImages[demoIndex]) {
        
            do {
                let image = try UIImage(withContentsOfURL: imageURL)
                blImageView.image = image
            } catch {
                NSLog("Error converting image URL: \(error)")
            }
        }
        
        // randomly select image
        demoIndex = (demoIndex + Int.random(in: 0...5)) % 5
    }
}

extension UIImage {
    
    convenience init?(withContentsOfURL url: URL) throws {
        let imageData = try Data(contentsOf: url)
        
        self.init(data: imageData)
    }
    
}
