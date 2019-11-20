//
//  SignUpViewController.swift
//  BucketList
//
//  Created by Dennis Rudolph on 11/18/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var bucketListController: BucketListController?

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createAccountButton.layer.cornerRadius = 3.0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     */
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        guard let bucketListController = bucketListController else { return }
        guard let username = usernameTextField.text,
            !username.isEmpty,
            let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty,
            let confirmPassword = confirmPasswordTextField.text,
            !confirmPassword.isEmpty else { return }
        guard confirmPassword == password else { return }
        
        let user = User(username: username, password: password, email: email)
        
        bucketListController.signUp(with: user) { (error) in
            if let error = error {
                print("Error occurred during sign up: \(error)")
            } else {
                DispatchQueue.main.async {
                    
                    let alertController = UIAlertController(title: "Sign Up Successful", message: "Welcome \(user.username)", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Get Started", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true) {
                        
                    }
                }
            }
        }
        
        bucketListController.signIn(username: username, password: password) { (error) in
            if let error = error {
                print("Error occurred during sign up: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
}
