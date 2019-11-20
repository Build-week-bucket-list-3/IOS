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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
