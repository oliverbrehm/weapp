//
//  MainTBC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 10.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class MainTBC: UITabBarController {
    
    var invitationListTVC : InvitationListTVC?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clearData()
    {
        self.invitationListTVC?.clearData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        for viewController in self.viewControllers! {
            if(viewController is UINavigationController) {
                let vc = (viewController as! UINavigationController).visibleViewController
                if(vc is InvitationListTVC) {
                    self.invitationListTVC = vc as? InvitationListTVC
                }
            }
        }
        
        if(!User.loggedIn()) {
            User.autoLogin { (success: Bool) in
                if(!success) {
                    self.performSegue(withIdentifier: "showLogin", sender: self)
                } else {
                    print("user auto logged in")
                    self.invitationListTVC?.userDidLogin()
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
