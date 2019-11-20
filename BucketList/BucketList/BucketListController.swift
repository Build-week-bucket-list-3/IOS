//
//  BucketListController.swift
//  BucketList
//
//  Created by Dennis Rudolph on 11/19/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation

class BucketListController {
    
    var bucketLists: [BucketList] = []
    
    var bearer: Bearer?
    
    let bucketListItemController = BucketListItemController()
    
    let baseURL = URL(string: "https://gcgsauce-bucketlist.herokuapp.com")!
    
    
    init() {
        bucketListItemController.bearer = self.bearer
    }

    
    // MARK: - BucketList CRUD Methods
    
    
    
    
    
    // MARK: - User methods
    
    //add login and logout and edit
    
        
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseURL.appendingPathComponent("/createnewuser")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                    completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                    return
                }
                
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
            }.resume()
        }
    
    func signIn(username: String, password: String, completion: @escaping (Error?) -> ()) {
        let signInURL = baseURL.appendingPathComponent("/login")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user = LoginUser(username: username, password: password)
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func logout(username: String, password: String, completion: @escaping (Error?) -> ()) {
        let signInURL = baseURL.appendingPathComponent("/logout")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user = LoginUser(username: username, password: password)
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}


//// For GiPyo
//override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//    tableView.reloadData()
//    if BucketListController.bearer == nil {
////       send to modal Login view performSegue(withIdentifier: "LogInSegue", sender: self)
//    } else {
////       fetch the bucket lists
//    }
//}
//
//if segue.identifier == "LogInSegue" {
//if let loginVC = segue.destination as? SignInViewController {
//    loginVC.bucketListController = bucketListController
//}
