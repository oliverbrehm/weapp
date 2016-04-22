//
//  Utility.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 22.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

extension UIViewController
{
    func presentAlert(title: String, message: String, cancelButtonTitle: String, animated: Bool)
    {
        self.presentAlert(title, message: message, cancelButtonTitle: cancelButtonTitle, animated: animated, completion: nil)
    }
    
    func presentAlert(title: String, message: String, cancelButtonTitle: String, animated: Bool, completion: ((UIAlertAction) -> Void)?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.Default, handler: completion))
        self.presentViewController(alert, animated: animated, completion: nil)
    }

}