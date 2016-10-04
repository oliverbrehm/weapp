//
//  JoinRequestList.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class JoinRequestList
{
    public let user: User
    
    init(for user: User) {
        self.user = user
    }
    
    private var joinRequests: [JoinRequest] = []
    
    func isEmpty() -> Bool
    {
        return self.joinRequests.count == 0
    }
    
    func count() -> Int
    {
        return self.joinRequests.count
    }
    
    func joinRequest(index: Int) -> JoinRequest
    {
        return self.joinRequests[index]
    }
    
    func fetch(max: Int, completion: @escaping ((Bool) -> Void))
    {
        let request = QueryJoinRequestList()
        
        let user = User.current
        if(user == nil) {
            completion(false)
            return
        }
        
        request.send(user!) { (success: Bool) in
            
            if(request.responseValue == false) {
                completion(false)
                return
            }
            
            self.joinRequests.append(contentsOf: request.joinRequests)
            
            completion(true)
        }
    }
}
