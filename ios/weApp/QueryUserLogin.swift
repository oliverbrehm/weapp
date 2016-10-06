//
//  QueryUserLogin.swift
//  weApp
//
//  Created by Oliver Brehm on 04.10.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation

open class QueryUserLogin: Query
{
    open var userId = ""
    open func send(_ mail: String, password: String, completion: @escaping ((Bool) -> Void))
    {
        let postData = "action=user_login&mail=\(mail)&password=\(password)"
        super.sendHTTPPost(data: postData, completion: completion)
    }
    
    open override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        
        if(elementName == "UserID") {
            self.userId = self.currentString
        }
    }
}
