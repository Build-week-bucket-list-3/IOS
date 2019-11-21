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
    
    var loggedInUser: User?
        
    let baseURL = URL(string: "https://bw-bucketlist.herokuapp.com/api")!
    
    // MARK: - User methods
    
    //add login and logout and edit
    
    
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseURL.appendingPathComponent("/users/register")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = "POST"
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
    
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
        let signInURL = baseURL.appendingPathComponent("/users/login")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = "POST"
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
                self.loggedInUser = user
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    
    
    func setUserID(token: Bearer, user: User, completion: @escaping (Error?) -> ()) {
        let allUsersURL = baseURL.appendingPathComponent("/users")
        
        var request = URLRequest(url: allUsersURL)
        request.httpMethod = "GET"
        request.setValue("\(token.token)", forHTTPHeaderField: "Authorization")
        
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
                let allUsers = try decoder.decode([User].self, from: data)
                for u in allUsers {
                    if u.username == user.username {
                        self.loggedInUser?.id = u.id
                    }
                }
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    
    // MARK: - Core Data CRUD
    
    func createBucketList(name: String, shareable: Bool, context: NSManagedObjectContext) {
        guard let loggedInUser = loggedInUser else { return }
        let bucketListRepresentation = BucketListRepresentation(id: nil, name: name, createdBy: loggedInUser, items: nil, shareable: shareable, sharedWith: nil)
        
        createBucketListToServer(bucketListRep: bucketListRepresentation) { (result) in
            do {
                let bucketListRep = try result.get()
                BucketList(bucketListRep: bucketListRep, context: context)
                CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error creating a new bucket list to server: \(error)")
            }
        }
    }
    
    func createBucketListItem(bucketList: BucketList, id: Int32, name: String, shareable: Bool, isCompleted: Bool, bucketListID: Int32, journalEntries: [URL], photos: [URL], videos: [URL], voiceMemos: [URL], context: NSManagedObjectContext) {
        
        let bucketListItem = BucketListItem(id: id, name: name, shareable: shareable, isCompleted: isCompleted, bucketListID: bucketListID, journalEntries: journalEntries, photos: photos, videos: videos, voiceMemos: voiceMemos)
        bucketList.items?.items.append(bucketListItem)
        
        updateBucketListToServer(bucketList: bucketList) { (result) in
            do {
                _ = try result.get()
                CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error updating the bucket list item to server: \(error)")
            }
        }
    }
    
    func updateBucketList(bucketList: BucketList, name: String, items: BucketListItems, shareable: Bool, sharedWith: Users, context: NSManagedObjectContext) {
        
        bucketList.name = name
        bucketList.items = items
        bucketList.shareable = shareable
        bucketList.sharedWith = sharedWith
        
        updateBucketListToServer(bucketList: bucketList) { (result) in
            do {
                _ = try result.get()
                CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error updating the bucket list to server: \(error)")
            }
        }
    }
    
    func deleteBucketList(bucketList: BucketList, context: NSManagedObjectContext) {
        context.performAndWait {
            deleteBucketListFromServer(bucketList: bucketList) { (result) in
                do {
                    let bucketList = try result.get()
                    context.delete(bucketList)
                    CoreDataStack.shared.save(context: context)
                } catch {
                    NSLog("Error deleting a bucket list from server: \(error)")
                }
            }
        }
    }
    
    // MARK: - Database CRUD
    
    func fetchAllBucketListsFromServer(completion: @escaping (NetworkingError?) -> Void = { _ in }) {
        completion(nil)
    }
    
    func createBucketListToServer(bucketListRep: BucketListRepresentation, completion: @escaping (Result<BucketListRepresentation, NetworkingError>) -> Void) {
        
        completion(.success(bucketListRep))
    }
    
    func updateBucketListToServer(bucketList: BucketList, completion: @escaping (Result<BucketList,Error>) -> Void) {
        
        completion(.success(bucketList))
    }
    
    func deleteBucketListFromServer(bucketList: BucketList, completion: @escaping (Result<BucketList,Error>) -> Void) {
        
        completion(.success(bucketList))
    }
    
    
    
}
