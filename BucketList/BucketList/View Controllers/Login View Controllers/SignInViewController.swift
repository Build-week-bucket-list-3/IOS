//
//  SignInViewController.swift
//  BucketList
//
//  Created by Dennis Rudolph on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    var bucketListController: BucketListController?

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.layer.cornerRadius = 3.0
        
    }
    
    @IBAction func createAccountButton(_ sender: UIButton) {
        
        
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateAccountSegue" {
            if let createVC = segue.destination as? SignUpViewController {
                createVC.bucketListController = bucketListController
            }
        }
    }
}
