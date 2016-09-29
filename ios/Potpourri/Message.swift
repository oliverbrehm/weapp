//
//  Message.swift
//  Potpourri
//
//  Created by Oliver Brehm on 29.09.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class Message
{
    public var text = ""
    public var ownerId : Int
    public var ownerName = ""
    public var time : Date
    
    init(text: String, ownerId: Int, ownerName: String, time: Date) {
        self.text = text
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.time = time
    }
}

open class MessageList
{
    var invitationId : Int
    
    private var messages : [Message] = []
    
    init(invitationId: Int) {
        self.invitationId = invitationId
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
        
        let request = HTTPPMessageListRequest()
        
        request.send(invitationId: self.invitationId) { (success: Bool) in
            if(request.responseValue == false) {
                completion(false)
                return
            }
            
            self.messages = request.messages
            
            completion(true)
        }
    }
}
