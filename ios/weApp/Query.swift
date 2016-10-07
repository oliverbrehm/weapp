//
//  Query.swift
//  weApp
//
//  Created by Oliver Brehm on 11.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class Query: NSObject, XMLParserDelegate
{
    open var responseValue = false
    open var sessionId = ""
    open var responseString = ""
    
    var currentString = ""
    
    let APIURL = "http://vocab-book.com/integrationsprojekt/develop/interface/API.php"
    
    public struct Action {
        struct User {
            static let Register   = "user_register"
            static let Login      = "user_login"
            static let Logout     = "user_logout"
            static let IsLoggedIn = "user_isLoggedIn"
            static let Query      = "user_query"
            static let Details    = "user_details"
        }
        
        struct Invitation {
            static let Create       = "invitation_create"
            static let PostMessage  = "invitation_postMessage"
            static let Messages      = "invitation_messages"
            static let Query        = "invitation_query"
            static let Details      = "invitation_details"
            static let Participants = "invitation_participants"
            static let Delete       = "invitation_delete"
            static let Update       = "invitation_update"
        }
    
        struct JoinRequest {
            static let Create   = "joinRequest_create"
            static let Query    = "joinRequest_query"
            static let Accept   = "joinRequest_accept"
            static let Reject   = "joinRequest_reject"
        }
    }
    
    public struct Arguments {
        static let Action = "action"
        
        struct User {
            static let Mail              = "mail"
            static let Password          = "password"
            static let FirstName         = "firstName"
            static let LastName          = "lastName"
            static let UserType          = "userType"
            static let Gender            = "gender"
            static let DateOfBirth       = "dateOfBirth"
            static let Nationality       = "nationality"
            static let DateOfImmigration = "dateOfImmigration"
            static let LocationLatitude  = "locationLatitude"
            static let LocationLongitude = "locationLongitude"
            static let UserId            = "userId"
        }

        struct Invitation {
            static let Name                 = "name"
            static let Description          = "description"
            static let MaxParticipants      = "maxParticipants"
            static let Date                 = "date"
            static let Time                 = "time"
            static let LocationCity         = "locationCity"
            static let LocationStreet       = "locationStreet"
            static let LocationStreetNumber = "locationStreetNumber"
            static let LocationLatitude     = "locationLatitude"
            static let LocationLongitude    = "locationLongitude"
            static let InvitationId         = "invitationId"
            static let Message              = "message"
            static let OwnerId              = "ownerId"
            static let ParticipatingUserId  = "participatingUserId"
        }
        
        struct JoinRequest {
            static let InvitationId     = "invitationId"
            static let UserId           = "userId"
            static let NumParticipants  = "numParticipants"
            static let JoinRequestId    = "joinRequestId"
        }
    }
    
    internal func sendHTTPPost(data: String, completion: @escaping ((Bool) -> Void))
    {
        let request = NSMutableURLRequest(url: URL(string: self.APIURL)!)
        // TODO use HTTPS? normally HTTP is not even supported (hack in Project -> target -> Info -> App Transport Security Settings)
        
        request.httpMethod = "POST"
        
        request.httpBody = data.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {
                print("error=\(error)")
                completion(false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            self.responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            print("responseString = \(self.responseString)")
            
            // cookies
            for cookie in HTTPCookieStorage.shared.cookies! {
                print(cookie.name)
                if(cookie.name == "PHPSESSID") {
                    self.sessionId = cookie.value
                }
            }
            
            print("sessionId: \(self.sessionId)")
            
            if(self.sessionId.isEmpty || self.responseString.isEmpty) {
                completion(false)
            } else {
                // get the xml response value
                let data = self.responseString.data(using: String.Encoding.utf8)
                let xmlParser = XMLParser(data: data!)
                xmlParser.delegate = self
                
                xmlParser.parse()
                
                completion(true)
            }
        }
        
        task.resume();
    }

    open func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if(elementName == "response") {
            if let success = attributeDict["success"] {
                self.responseValue = NSString(string: success).boolValue
                print("RESPONSE: \(self.responseValue)")
            }
        }
        
        self.currentString = ""
    }
    
    open func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    open func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        
    }
    
    open func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentString.append(string)
    }
}
