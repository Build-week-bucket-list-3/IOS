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
    
    var bucketList: BucketList?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        //users/bucketlist DELETE request 
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbeddedSegue" {
            if let collectionVC = segue.destination as? BucketListItemCollectionViewController {
                collectionVC.bucketListController = bucketListController
                collectionVC.bucketList = bucketList
            }
        } else if segue.identifier == "CreateBLISegue" {
            if let createVC = segue.destination as? CreateBucketListItemViewController {
                createVC.bucketListController = bucketListController
                createVC.bucketList = bucketList
            }
        } else if segue.identifier == "BLinfoSegue" {
            if let infoVC = segue.destination as? BLinfoViewController {
                infoVC.bucketListController = bucketListController
            }
        }
    }
}
