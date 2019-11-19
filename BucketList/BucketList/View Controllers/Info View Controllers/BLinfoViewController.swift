//
//  BLinfoViewController.swift
//  BucketList
//
//  Created by Dennis Rudolph on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

enum Type {
    case item
    case list
}

class BLinfoViewController: UIViewController {
    
    // make sure prepare method from VC that this is segueing from passes in a type as well as the controller and item/list
    
    var bucketListController: BucketListController?
    var bucketList: BucketList?
    var bucketListItem: BucketListItem?
    
    var type: Type?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sharedWithLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLabels()
    }
    
    func setupLabels() {
        if type == .list {
            guard let bucketList = bucketList else { return }
//            self.title = bucketList.
            
            // Waiting for BL model.
//            nameLabel.text = bucketList.
//            createdByLabel.text = bucketList.
//            dateLabel.text = bucketList.
//            lastUpdatedLabel.text = bucketList.
//            statusLabel.text = bucketList.
//            sharedWithLabel.text = bucketList.
//            itemsLabel.text = bucketList.

            
        } else if type == .item {
//            self.title = bucketListItem.
            
            // Waiting for BLitem model
//            nameLabel.text = bucketListItem.
//            createdByLabel.text = bucketListItem.
//            dateLabel.text = bucketListItem.
//            lastUpdatedLabel.text = bucketListItem.
//            statusLabel.text = bucketListItem.
//            sharedWithLabel.text = bucketListItem.
//            itemsLabel.text = bucketListItem.
            
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShareSegue" {
            if let shareVC = segue.destination as? BLshareViewController {
                shareVC.bucketListController = bucketListController
                shareVC.type = type
                if type == .list {
                    shareVC.bucketList = bucketList
                } else if type == .item {
                    shareVC.bucketListItem = bucketListItem
                }
            }
        }
    }
}
