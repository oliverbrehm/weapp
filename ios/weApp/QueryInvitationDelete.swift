//
//  QueryInvitationDelete.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryInvitationDelete: Query
{
    open func send(_ invitationId: Int, completion: @escaping ((Bool) -> Void))
    {
        let postData = "\(Arguments.Action)=\(Action.Invitation.Delete)" +
        "&id=\(invitationId)"
        
        super.sendHTTPPost(data: postData, completion: completion)
    }
}
