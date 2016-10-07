//
//  InvitationMessageRequest.swift
//  weApp
//
//  Created by Oliver Brehm on 29.09.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryMessagePost: Query
{
    open func send(invitationId: Int, message: String, completion: @escaping ((Bool) -> Void))
    {
        let postData = "\(Arguments.Action)=\(Action.Invitation.PostMessage)&id=\(invitationId)&\(Arguments.Invitation.Message)=\(message)"
        super.sendHTTPPost(data: postData, completion: completion)
    }
}
