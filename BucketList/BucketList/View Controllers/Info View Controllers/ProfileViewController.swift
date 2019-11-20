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
    var saveable: Bool = false
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var sharedBucketListsLabel: UITextField!
    @IBOutlet weak var privateBucketListsLabel: UITextField!
    
    override func viewDidLoad() {
        usernameLabel.allowsEditingTextAttributes = false
        emailLabel.allowsEditingTextAttributes = false
        passwordLabel.allowsEditingTextAttributes = false
        sharedBucketListsLabel.allowsEditingTextAttributes = false
        privateBucketListsLabel.allowsEditingTextAttributes = false
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        guard let newUsername = usernameLabel.text, !newUsername.isEmpty, let newEmail = emailLabel.text, !newEmail.isEmpty, let newPassword = passwordLabel.text, !newPassword.isEmpty else { return }
        
        //users/user
        //POST request to update the current user object (username, password and email)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        saveable.toggle()
        usernameLabel.allowsEditingTextAttributes = true
        emailLabel.allowsEditingTextAttributes = true
        passwordLabel.allowsEditingTextAttributes = true
    }
}
