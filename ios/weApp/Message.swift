//
//  Message.swift
//  weApp
//
//  Created by Oliver Brehm on 29.09.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class Message
{
    let messageId: Int
    
    public var text = ""
    public var time : Date
    
    let owner : User
    
    init(id: Int, text: String, ownerId: Int, ownerName: String, time: Date) {
        self.messageId = id
        
        self.text = text
        self.time = time
        
        self.owner = User(id: ownerId, sessionId: ownerName)
    }
}
