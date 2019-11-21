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
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let bucketListController = bucketListController else { return }
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        bucketListController.signIn(with: user) { (error) in
            if let error = error {
                print("Error occurred during sign in: \(error)")
            } else {
                guard let token = bucketListController.bearer else { return }
                bucketListController.setUserID(token: token, user: user) { (error) in
                    if let error = error {
                        print("Error occurred during sign in: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
            }
        }
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
