//
//  UserRegistrationVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 14.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class UserRegistrationVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var agreementSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendLoginRequest(nvc: RegistrationNVC)
    {
        self.stackView.hidden = true
        self.activityIndicator.startAnimating()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            User.login(nvc.email, password: nvc.password)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.password1TextField.resignFirstResponder()
        self.password2TextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField === self.emailTextField) {
            self.password1TextField.becomeFirstResponder()
        } else if(textField === self.password1TextField) {
            self.password2TextField.becomeFirstResponder()
        } else if(textField === self.password2TextField) {
            self.password2TextField.resignFirstResponder()
        }
        
        return true
    }
    
    func sendRegisterRequest(nvc: RegistrationNVC)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            let registerRequest = HTTPUserRegisterRequest()
            registerRequest.send(nvc.email, password: nvc.password, firstName: nvc.firstName, lastName: nvc.lastName, userType: nvc.userType, gender: nvc.gender, dateOfBirth: NSDate.distantPast(), nationality: "", email: nvc.email, dateOfImmigration: NSDate.distantPast(), locationLatitude: 0, locationLongitude: 0)
            // TODO remove request sending to User class
            
            dispatch_async(dispatch_get_main_queue()) {
                if(registerRequest.responseValue == false) {
                    let alert = UIAlertController(title: "Register", message: "Error registering", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                
                let alert = UIAlertController(title: "Register", message: "Account successfully created", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                    self.sendLoginRequest(nvc)
                }))

                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func registerButtonClicked(sender: AnyObject) {
        if(self.emailTextField.text!.isEmpty || self.password1TextField.text!.isEmpty || self.password2TextField.text!.isEmpty) {
            let alert = UIAlertController(title: "Register", message: "Please enter email adress and password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if(password1TextField.text != password2TextField.text) {
            let alert = UIAlertController(title: "Register", message: "The passwords do not match", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.password1TextField.text = ""
            self.password2TextField.text = ""
            return
        }
        
        if(!self.agreementSwitch.on) {
            let alert = UIAlertController(title: "Register", message: "Please agree to the license agreement", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if let nvc = self.parentViewController as? RegistrationNVC {
            nvc.email = self.emailTextField.text!
            nvc.password = self.password1TextField.text!
            
            self.sendRegisterRequest(nvc)
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
