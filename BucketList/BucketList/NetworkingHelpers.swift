//
//  NetworkingHelpers.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/19/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkingError: Error {
    case noData
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode(Int)
    case badDecode
    case badEncode
    case noRepresentation
}

enum HeaderNames: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}
