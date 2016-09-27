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
    func presentAlert(_ title: String, message: String, cancelButtonTitle: String, animated: Bool)
    {
        self.presentAlert(title, message: message, cancelButtonTitle: cancelButtonTitle, animated: animated, completion: nil)
    }
    
    func presentAlert(_ title: String, message: String, cancelButtonTitle: String, animated: Bool, completion: ((UIAlertAction) -> Void)?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.default, handler: completion))
        self.present(alert, animated: animated, completion: nil)
    }

}
