//
//  ProfileViewController.swift
//  BucketList
//
//  Created by Dennis Rudolph on 11/19/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: User?
    var bucketListController: BucketListController?
    
    @IBOutlet weak var usernameLabel: UTextField!
    @IBOutlet weak var emailLabel: UTextField!
    @IBOutlet weak var passwordLabel: UTextField!
    @IBOutlet weak var sharedBucketListsLabel: UTextField!
    @IBOutlet weak var privateBucketListsLabel: UTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func editButtonTapped(_ sender: UIButton) {
        //users/user
        //POST request to update the current user object (username, password and email)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
