//
//  BucketListController.swift
//  BucketList
//
//  Created by Dennis Rudolph on 11/19/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData
import OAuthSwift

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
    
    func signIn(username: String, password: String) {
        let oauthswift = OAuth2Swift(
            consumerKey:    "lambda-client",
            consumerSecret: "lambda-secret",
            authorizeUrl:   "https://gcgsauce-bucketlist.herokuapp.com/login",
            accessTokenUrl: "https://gcgsauce-bucketlist.herokuapp.com/login",
            responseType:   "token"
        )
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-swift://gcgsauce-bucketlist.herokuapp.com")!,
            scope: "", state: "") { result in
                switch result {
                case .success(let (credential, _, _)):
                    print("It worked the token is \(credential.oauthToken)")
                    self.bearer?.token = credential.oauthToken
                case .failure:
                    print("Error fetching token.")
                }
        }
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
        self.bearer = nil
    }
    
    
    // MARK: - Core Data CRUD
    
    func createBucketList(id: Int32, name: String, createdBy: User, items: BucketListItems, shareable: Bool, sharedWith: Users, context: NSManagedObjectContext) {
        
        let bucketListRepresentation = BucketListRepresentation(id: id, name: name, createdBy: createdBy, items: items, shareable: shareable, sharedWith: sharedWith)
    }
    
    
    
    
}
