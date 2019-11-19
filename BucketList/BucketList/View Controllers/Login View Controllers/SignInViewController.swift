//
//  SignInViewController.swift
//  BucketList
//
//  Created by Dennis Rudolph on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.layer.cornerRadius = 3.0
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func createAccountButton(_ sender: UIButton) {
        
        
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
    }
    
}
