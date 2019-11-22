//
//  CreateBucketListViewController.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class CreateBucketListViewController: UIViewController {
    @IBOutlet weak var nameTextFIeld: UITextField!
    
    var bucketListController: BucketListController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createNewBucketList(_ sender: Any) {
        guard let name = nameTextFIeld.text, !name.isEmpty,
            let bucketListController = bucketListController,
            let loggedInUser = bucketListController.loggedInUser else { return }
        
        bucketListController.createBucketList(name: name, createdBy: loggedInUser.username, context: CoreDataStack.shared.mainContext)
        
        navigationController?.popViewController(animated: true)
    }
}
