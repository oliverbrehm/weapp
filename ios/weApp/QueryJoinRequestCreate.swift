//
//  QueryInvitationJoin.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryJoinRequestCreate: Query
{    
    open func send(_ invitationId: Int, userId: Int, numParticipants: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "\(Arguments.Action)=\(Action.JoinRequest.Create)" +
            "&\(Arguments.JoinRequest.InvitationId)=\(invitationId)" +
            "&\(Arguments.JoinRequest.UserId)=\(userId)" +
        "&\(Arguments.JoinRequest.NumParticipants)=\(numParticipants)"
        
        super.sendHTTPPost(data: postData, completion: completion)
    }
}
