//
//  BLshareViewController.swift
//  BucketList
//
//  Created by Dennis Rudolph on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class BLshareViewController: UIViewController {
    
    var bucketListController: BucketListController?
    
    var bucketList: BucketList?
    
    var bucketListItem: BucketListItem?
    
    var type: Type?

    @IBOutlet weak var BLusernameTextField: UITextField!
    @IBOutlet weak var updatePrivilegesButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

 
    @IBAction func updatePrivilegesButtonTapped(_ sender: UIButton) {
        if updatePrivilegesButton.titleLabel?.text == "☐ Grant \"Update\" Privileges to this user" {
            updatePrivilegesButton.titleLabel?.text = "☑︎ Grant \"Update\" Privileges to this user"
        } else {
            updatePrivilegesButton.titleLabel?.text = "☐ Grant \"Update\" Privileges to this user"
        }
    }
    
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard updatePrivilegesButton.titleLabel?.text == "☑︎ Grant \"Update\" Privileges to this user" else { return }
        
        guard let username = BLusernameTextField.text, !username.isEmpty else { return }
        
        if type == .list {
            guard let list = bucketList else { return }
            
            // run share list method thru controller with username and list as argument AND DISMISS MODAL VIEW
            
        } else if type == .item {
            guard let item = bucketListItem else { return }
            
            // run share item method thru controller with username and item as argument AND DISMISS MODAL VIEW
            
        }
    }
    
}
