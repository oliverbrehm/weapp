//
//  InvitationList.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class InvitationList
{
    enum SorginCriteria
    {
        case Area
        case Date
    }
    
    var sortingCriteria = SorginCriteria.Date
    var city = ""
    
    private var invitations : [Invitation] = []
    
    var runningQuery = false
    
    init(city: String, sortingCriteria: SorginCriteria) {
        self.sortingCriteria = sortingCriteria
        self.city = city
    }
    
    func count() -> Int
    {
        return self.invitations.count
    }
    
    func isEmpty() -> Bool
    {
        return count() == 0
    }
    
    func invitation(index: Int) -> Invitation
    {
        return self.invitations[index]
    }
    
    func fetch(number: Int, completion: @escaping ((Bool) -> Void))
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let request = QueryInvitationList()
        
        request.send() { (success: Bool) in
            if(request.responseValue == false) {
                self.runningQuery = false; completion(false)
                return
            }
            
            self.invitations = request.invitations
            
            self.runningQuery = false; completion(true)
        }
        
    }
    
    func fetch(owner: User, number: Int, completion: @escaping ((Bool) -> Void))
    {
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let request = QueryInvitationList()
        
        request.send(owner: owner) { (success: Bool) in
            if(request.responseValue == false) {
                self.runningQuery = false; completion(false)
                return
            }
            
            self.invitations = request.invitations
            
            self.runningQuery = false; completion(true)
        }

    }
    
    func fetch(participatingUser: User, number: Int, completion: @escaping ((Bool) -> Void))
    {
        // TODO consider number
        // TODO consider sorting
        
        if(self.runningQuery) { completion(false); return }
        self.runningQuery = true
        
        let request = QueryInvitationList()

        request.send(participatingUser: participatingUser) { (success: Bool) in
            if(request.responseValue == false) {
                self.runningQuery = false; completion(false)
                return
            }
            
            self.invitations = request.invitations
            
            self.runningQuery = false; completion(true)
        }
    }
    
    func refresh(max: Int, completion: @escaping ((Bool) -> Void))
    {
        self.invitations.insert(Invitation(invitationId: 0, name: "REFRESH DUMMY"), at: 0)
    }
}
