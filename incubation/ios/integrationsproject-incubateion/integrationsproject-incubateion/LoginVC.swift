//
//  LoginVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 10.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var autologinSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.mailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField === mailTextField) {
            passwordTextField.becomeFirstResponder()
        } else if(textField == passwordTextField) {
            self.loginButtonPressed(self.loginButton)
        }
        return true
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        self.mailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        let mail = self.mailTextField.text!
        let password = self.passwordTextField.text!
        
        let loginButton = sender as! UIButton
        
        if(mail.isEmpty || password.isEmpty) {
            self.presentAlert("Login", message: "Please enter your mail adress and password", cancelButtonTitle: "OK", animated: true)
        } else {
            self.activityIndicator.startAnimating()
            loginButton.hidden = true;
            
            NSUserDefaults.standardUserDefaults().setBool(self.autologinSwitch.on, forKey: "autologinEnabled")
            
            if(self.autologinSwitch.on) {
                NSUserDefaults.standardUserDefaults().setObject(mail, forKey: "autologinMail")
                NSUserDefaults.standardUserDefaults().setObject(password, forKey: "autologinPassword")
                print("autologin enabled")
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                let user = User.login(mail, password: password)
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if(user == nil) {
                        self.presentAlert("Login failed", message: "Invalid mail adress or password", cancelButtonTitle: "OK", animated: true)
                    } else {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
                    self.activityIndicator.stopAnimating()
                    loginButton.hidden = false
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
