//
//  MessageList.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class MessageList
{
    var invitation : Invitation
    
    private var messages : [Message] = []
    
    init(invitation : Invitation) {
        self.invitation = invitation
    }
    
    func count() -> Int
    {
        return self.messages.count
    }
    
    func isEmpty() -> Bool
    {
        return count() == 0
    }
    
    func message(index: Int) -> Message
    {
        return self.messages[index]
    }
    
    func fetch(max: Int, completion: @escaping ((Bool) -> Void))
    {
        // TODO consider max
        
        let request = QueryMessageList()
        
        if(self.invitation == nil) {
            completion(false); return
        }
        
        request.send(invitationId: self.invitation.invitationId) { (success: Bool) in
            if(request.responseValue == false) {
                completion(false)
                return
            }
            
            self.messages = request.messages
            
            completion(true)
        }
    }
}
