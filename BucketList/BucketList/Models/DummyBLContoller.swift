//
//  DummyBLContoller.swift
//  BucketList
//
//  Created by Gi Pyo Kim on 11/20/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import OAuthSwift

class dummyController {
    var bucketLists: [BucketList] = []
    
    var bearer: Bearer?
    
    let bucketListItemController = BucketListItemController()
    
    let baseURL = URL(string: "https://gcgsauce-bucketlist.herokuapp.com")!
    
    
    init() {
        bucketListItemController.bearer = self.bearer
    }
    
    // need OAuth figured out
}
