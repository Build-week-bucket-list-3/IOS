//
//  BucketListItemViewController.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class BucketListItemViewController: UIViewController {
    
    var bucketListController: BucketListController?
    
    var bucketList: BucketList? {
        didSet {
            // fetchitems()
            self.title = bucketList?.name
        }
    }
    
    var items: [BucketListItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbeddedSegue" {
            if let collectionVC = segue.destination as? BucketListItemCollectionViewController {
                collectionVC.bucketListController = bucketListController
                collectionVC.bucketList = bucketList
                collectionVC.items = items
            }
        } else if segue.identifier == "CreateBLISegue" {
            if let createVC = segue.destination as? CreateBucketListItemViewController {
                createVC.bucketListController = bucketListController
                createVC.bucketList = bucketList
            }
        } else if segue.identifier == "EditInfoSegue" {
            if let infoVC = segue.destination as? CreateBucketListViewController {
                infoVC.bucketListController = bucketListController
                infoVC.bucketList = bucketList
            }
        } else if segue.identifier == "ItemDetailSegue" {
            if let createVC = segue.destination as? BLIDetailViewController {
                createVC.bucketListController = bucketListController
                createVC.bucketList = bucketList
                createVC.item = item
            }
        }
    }
}
