//
//  BucketListItemController.swift
//  BucketList
//
//  Created by Dennis Rudolph on 11/19/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation

class BucketListItemController {
    
    let baseURL = URL(string: "https://gcgsauce-bucketlist.herokuapp.com")!
    var bucketListItems: [BucketListItem] = []
    var bearer: Bearer?
    
    // Network CRUD Methods
//    func createBucketListItemToServer(item: BucketListItem, completion: @escaping (Result<BucketListItem, NetworkingError>) -> Void) {
//        guard let bearer = bearer else {
//            completion(Result.failure(NetworkingError.noBearer))
//            return
//        }
//        
//        let requestURL = baseURL
//            .appendingPathComponent("")
//        
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
//        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
//
//        let encoder = JSONEncoder()
//        
//        do {
//            request.httpBody = try encoder.encode(item)
//        } catch {
//            NSLog("Error encoding new bucket list item: \(error)")
//            completion(.failure(.badEncode))
//        }
//        
//        URLSession.shared.dataTask(with: request) { (_, response, error) in
//            
//            if let error = error {
//                NSLog("Error posting new bucket list item: \(error)")
//                completion(.failure(.serverError(error)))
//            }
//            
//            if let response = response as? HTTPURLResponse,
//                response.statusCode != 200 {
//                completion(.failure(.unexpectedStatusCode(response.statusCode)))
//                return
//            }
//            
//            completion(.success(item))
//            
//        }.resume()
//    }
    
//    func updateBucketListItemToServer(item: BucketListItem, completion: @escaping (Result<BucketListItem, NetworkingError>) -> Void) {
//        
//        guard let bearer = bearer else {
//            completion(Result.failure(.noBearer))
//            return
//        }
//        
//        let requestURL = baseURL
//            .appendingPathComponent("")
//        
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("\(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
//        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
//        
//        let encoder = JSONEncoder()
//        
//        do {
//            request.httpBody = try encoder.encode(ReceiptRepresentation)
//        } catch {
//            NSLog("Error encoding receipt representation: \(error)")
//            completion(.badEncode)
//            return
//        }
//        
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            
//            if let error = error {
//                NSLog("Error PUTting receipt: \(error)")
//                completion(.serverError(error))
//            }
//            
//            if let response = response as? HTTPURLResponse,
//                response.statusCode != 201 {
//                NSLog("Unexpected status code: \(response.statusCode)")
//                completion(.unexpectedStatusCode(response.statusCode))
//                return
//            }
//            
//            guard let data = data else {
//                NSLog("No id returned after adding a new receipt")
//                completion(.noData)
//                return
//            }
//            
//            do {
//                let id = try JSONDecoder().decode(ReceiptID.self, from: data)
//                self.receiptID = Int64(id.receiptID)
//                completion(nil)
//            } catch {
//                NSLog("Could not decode receipt ID: \(error)")
//                completion(.badDecode)
//            }
//            
//        }.resume()
//        
//    }
}
