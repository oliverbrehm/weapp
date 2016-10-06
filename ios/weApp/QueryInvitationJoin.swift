//
//  QueryInvitationJoin.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryInvitationJoin: Query
{    
    open func send(_ invitationId: Int, userId: Int, numParticipants: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=invitation_join_request" +
            "&id=\(invitationId)" +
            "&userId=\(userId)" +
        "&numParticipants=\(numParticipants)"
        
        super.sendHTTPPost(data: postData, completion: completion)
    }
}
