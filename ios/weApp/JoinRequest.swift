//
//  JoinRequest.swift
//  weApp
//
//  Created by Oliver Brehm on 23.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class JoinRequest
{
    let requestId: Int

    let numParticipants: Int
    let maxParticipants: Int
    
    let user: User
    let invitation: Invitation
    
    init(requestId: Int, requestingUserId: Int, requestingUserFirstName: String, invitationId: Int, numParticipants: Int, maxParticipants: Int, invitationName: String) {
        self.requestId = requestId
        
        self.user = User(id: requestId, firstName: requestingUserFirstName)
        
        self.numParticipants = numParticipants
        self.maxParticipants = maxParticipants
        
        self.invitation = Invitation(invitationId: invitationId, name: invitationName)
    }
}
