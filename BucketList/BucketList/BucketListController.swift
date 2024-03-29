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
    
    init() {
        fetchAllBucketListsFromServer()
    }
    
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
                let allUsersDict = try decoder.decode([String: [User]].self, from: data)
                
                if let allUsers = allUsersDict["user"] {
                    for u in allUsers {
                        if u.username == user.username {
                            self.loggedInUser?.id = u.id
                        }
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
    
    
    // MARK: - Core Data Bucket List CRUD
    
    func createBucketList(name: String, createdBy: String?, context: NSManagedObjectContext) {
        guard let loggedInUser = loggedInUser, let userID = loggedInUser.id else { return }
        
        let bucketListRepresentation = BucketListRepresentation(id: nil, name: name, createdBy: loggedInUser.username, userID: userID)
        
        createBucketListToServer(bucketListRep: bucketListRepresentation) { (result) in
            do {
                _ = try result.get()
                // Need to call this to update bucket list ID
                self.fetchAllBucketListsFromServer()
            } catch {
                NSLog("Error creating a new bucket list to server: \(error)")
            }
        }
    }
    
    
    
    func updateBucketList(bucketList: BucketList, name: String, context: NSManagedObjectContext) {
        
        bucketList.name = name
        
        updateBucketListToServer(bucketList: bucketList) { (result) in
            do {
                _ = try result.get()
                CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error updating the bucket list to server: \(error)")
            }
        }
    }
    
    // Used for fetchAllBucketListsFromServer()
    func updateFetchedBucketListsToCoreData(with representations: [BucketListRepresentation]) {
        
        let identifiersToFetch = representations.map({ $0.id })
        // [[id]: [ReceiptRepresentation]]
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var bucketListsToCreate = representationsByID
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            
            do {
                let fetchRequest: NSFetchRequest<BucketList> = BucketList.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id IN %@", identifiersToFetch)
                
                let existingBucketLists = try context.fetch(fetchRequest)
                
                //Update the ones we do have
                for bucketList in existingBucketLists {
                    
                    // Grab the Representation that corresponds to this bucket list
                    let id = bucketList.id
                    guard let representation = representationsByID[id] else { continue }
                    
                    update(bucketList: bucketList, with: representation)
                    bucketListsToCreate.removeValue(forKey: id)
                }
                
                // bucket lists that don't exist in Core Data already
                for representation in bucketListsToCreate.values {
                    BucketList(bucketListRep: representation, context: context)
                }
                
                // Persist all the changes (updating and creating of bucket lists) to Core Data
                CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error fetching bucket lists from persistent store: \(error)")
            }
        }
    }
    
    // Used for updateFetchedBucketListsToCoreData()
    func update(bucketList: BucketList, with representation: BucketListRepresentation) {
        guard let id = representation.id else { return }
        
        bucketList.id = id
        bucketList.name = representation.name
        bucketList.createdBy = representation.createdBy
        bucketList.userID = representation.userID
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
    
    // MARK: - Core Data Bucket List Item CRUD
    
    func createBucketListItem(bucketList: BucketList, itemName: String, journalEntry: String?, photo: String?) {
        
        let bucketListIteRep = BucketListItemRepresentation(id: nil, itemName: itemName, journalEntry: journalEntry, photo: photo, completed: false, bucketID: bucketList.id)
        
        createBucketListItemToServer(bucketListItemRep: bucketListIteRep) { (result) in
            do {
                _ = try result.get()
                // Need to call this to update bucket list item ID
                self.fetchAllBucketListItemsFromServer()
            } catch {
                NSLog("Error creating bucket list item to server: \(error)")
            }
        }
    }
    
    func updateBucketListItem(bucketListItem: BucketListItem, itemName: String, journalEntry: String?, photo: String?, completed: Bool, context: NSManagedObjectContext) {
        bucketListItem.itemName = itemName
        bucketListItem.journalEntry = journalEntry
        bucketListItem.photo = photo
        bucketListItem.completed = completed
        
        updateBucketListItemToServer(bucketListItem: bucketListItem) { (result) in
            do {
                _ = try result.get()
                CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error updating the bucket list item to server: \(error)")
            }
        }
    }
    
    // Used for fetchAllBucketListItemsFromServer()
    func updateFetchedBucketListItemsToCoreData(with representations: [BucketListItemRepresentation]) {
        
        let identifiersToFetch = representations.map({ $0.id })
        // [[id]: [ReceiptRepresentation]]
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var bucketListItemsToCreate = representationsByID
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            
            do {
                let fetchRequest: NSFetchRequest<BucketListItem> = BucketListItem.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id IN %@", identifiersToFetch)
                
                let existingBucketListItems = try context.fetch(fetchRequest)
                
                //Update the ones we do have
                for bucketListItem in existingBucketListItems {
                    
                    // Grab the Representation that corresponds to this bucket list item
                    let id = bucketListItem.id
                    guard let representation = representationsByID[id] else { continue }
                    
                    update(bucketListItem: bucketListItem, with: representation)
                    bucketListItemsToCreate.removeValue(forKey: id)
                }
                
                // bucket lists that don't exist in Core Data already
                for representation in bucketListItemsToCreate.values {
                    BucketListItem(bucketListItemRep: representation, context: context)
                }
                
                // Persist all the changes (updating and creating of items) to Core Data
                CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error fetching bucket list items from persistent store: \(error)")
            }
        }
    }
    
    func deleteBucketListItem(bucketListItem: BucketListItem, context: NSManagedObjectContext) {
        context.performAndWait {
            deleteBucketListItemFromServer(bucketListItem: bucketListItem) { (result) in
                do {
                    let bucketListItem = try result.get()
                    context.delete(bucketListItem)
                    CoreDataStack.shared.save(context: context)
                } catch {
                    NSLog("Error deleting a bucket list item from server: \(error)")
                }
            }
        }
    }
    
    // Used for updateFetchedBucketListsToCoreData()
    func update(bucketListItem: BucketListItem, with representation: BucketListItemRepresentation) {
        guard let id = representation.id else { return }
        
        bucketListItem.id = id
        bucketListItem.itemName = representation.itemName
        bucketListItem.journalEntry = representation.journalEntry
        bucketListItem.photo = representation.photo
        bucketListItem.completed = representation.completed
        bucketListItem.bucketID = representation.bucketID
    }
    
    // MARK: - Database Bucket List CRUD
    
    func fetchAllBucketListsFromServer(completion: @escaping (NetworkingError?) -> Void = { _ in }) {
        guard let bearer = bearer else { return }
        
        let requestURL = baseURL.appendingPathComponent("buckets")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(bearer.token, forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error fetching all bucket lists: \(error)")
                completion(.serverError(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Unexpected status code: \(response.statusCode)")
                completion(.unexpectedStatusCode(response.statusCode))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from bucket list fetch data task")
                completion(.noData)
                return
            }
            
            do {
                let bucketLists = try JSONDecoder().decode([BucketListRepresentation].self, from: data)
                self.updateFetchedBucketListsToCoreData(with: bucketLists)
            } catch {
                NSLog("Error decoding BucketListRepresentation: \(error)")
                completion(.badDecode)
            }
            completion(nil)
        }.resume()
    }
    
    func createBucketListToServer(bucketListRep: BucketListRepresentation, completion: @escaping (Result<BucketListRepresentation, NetworkingError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("buckets")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("\(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        do {
            request.httpBody = try JSONEncoder().encode(bucketListRep)
        } catch {
            NSLog("Error encoding bucket list representation: \(error)")
            completion(.failure(.badEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let error = error {
                NSLog("Error POSTing bucket list: \(error)")
                completion(.failure(.serverError(error)))
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                NSLog("Unexpected status code: \(response.statusCode)")
                completion(.failure(.unexpectedStatusCode(response.statusCode)))
                return
            }
            
            // No data to decode, need to get the id seperately
            completion(.success(bucketListRep))
        }.resume()
    }
    
    func updateBucketListToServer(bucketList: BucketList, completion: @escaping (Result<BucketList,NetworkingError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        guard let bucketListRep = bucketList.bucketListRepresentation else {
            completion(.failure(.noRepresentation))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("buckets").appendingPathComponent(String(bucketList.id))
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("\(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        
        do {
            request.httpBody = try JSONEncoder().encode(bucketListRep)
        } catch {
            NSLog("Error encoding bucket list representation: \(error)")
            completion(.failure(.badEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let error = error {
                NSLog("Error PUTing bucket list: \(error)")
                completion(.failure(.serverError(error)))
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                NSLog("Unexpected status code: \(response.statusCode)")
                completion(.failure(.unexpectedStatusCode(response.statusCode)))
                return
            }
            
            // No data to decode, need to get the id seperately
            completion(.success(bucketList))
        }.resume()
    }
    
    func deleteBucketListFromServer(bucketList: BucketList, completion: @escaping (Result<BucketList,NetworkingError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("buckets").appendingPathComponent(String(bucketList.id))
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("\(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error deleting bucket list \(bucketList.id) from server: \(error)")
                completion(.failure(.serverError(error)))
                return
            }
            completion(.success(bucketList))
        }.resume()
    }
    
    // MARK: - Database Bucket List Item CRUD
    
    func fetchAllBucketListItemsFromServer(completion: @escaping (NetworkingError?) -> Void = { _ in }) {
        guard let bearer = bearer else { return }
        
        let requestURL = baseURL.appendingPathComponent("items")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(bearer.token, forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error fetching all bucket list items: \(error)")
                completion(.serverError(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Unexpected status code: \(response.statusCode)")
                completion(.unexpectedStatusCode(response.statusCode))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from bucket list item fetch data task")
                completion(.noData)
                return
            }
            
            do {
                let bucketListItems = try JSONDecoder().decode([BucketListItemRepresentation].self, from: data)
                self.updateFetchedBucketListItemsToCoreData(with: bucketListItems)
            } catch {
                NSLog("Error decoding BucketListItemRepresentation: \(error)")
                completion(.badDecode)
            }
            completion(nil)
        }.resume()
    }

    func createBucketListItemToServer(bucketListItemRep: BucketListItemRepresentation, completion: @escaping (Result<BucketListItemRepresentation, NetworkingError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("items")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("\(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        do {
            request.httpBody = try JSONEncoder().encode(bucketListItemRep)
        } catch {
            NSLog("Error encoding bucket list item representation: \(error)")
            completion(.failure(.badEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let error = error {
                NSLog("Error POSTing bucket list item: \(error)")
                completion(.failure(.serverError(error)))
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                NSLog("Unexpected status code: \(response.statusCode)")
                completion(.failure(.unexpectedStatusCode(response.statusCode)))
                return
            }
            
            // No data to decode, need to get the id seperately
            completion(.success(bucketListItemRep))
        }.resume()
    }
    
    func updateBucketListItemToServer(bucketListItem: BucketListItem, completion: @escaping (Result<BucketListItem,NetworkingError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        guard let bucketListItemRep = bucketListItem.bucketListItemRepresentation else {
            completion(.failure(.noRepresentation))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("items").appendingPathComponent(String(bucketListItem.id))
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("\(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        
        do {
            request.httpBody = try JSONEncoder().encode(bucketListItemRep)
        } catch {
            NSLog("Error encoding bucket list item representation: \(error)")
            completion(.failure(.badEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let error = error {
                NSLog("Error PUTing bucket list item: \(error)")
                completion(.failure(.serverError(error)))
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                NSLog("Unexpected status code: \(response.statusCode)")
                completion(.failure(.unexpectedStatusCode(response.statusCode)))
                return
            }
            
            // No data to decode, need to get the id seperately
            completion(.success(bucketListItem))
        }.resume()
    }
    
    func deleteBucketListItemFromServer(bucketListItem: BucketListItem, completion: @escaping (Result<BucketListItem,NetworkingError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(.failure(.noBearer))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("items").appendingPathComponent(String(bucketListItem.id))
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("\(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error deleting bucket list item \(bucketListItem.id) from server: \(error)")
                completion(.failure(.serverError(error)))
                return
            }
            completion(.success(bucketListItem))
        }.resume()
    }
    
}
