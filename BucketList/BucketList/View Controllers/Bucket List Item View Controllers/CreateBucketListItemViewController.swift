//
//  CreateBucketListItemViewController.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class CreateBucketListItemViewController: UIViewController {
    
    var bucketListController: BucketListController?
    var bucketList: BucketList?
    
    @IBOutlet weak var itemNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        guard let name = itemNameTextField.text, !name.isEmpty else { return }
//        bucketlists/bucketlist/{bucketlistid}/item  call function using this endpoint to create a new item to the bucketlist
    }

}
