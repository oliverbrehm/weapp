//
//  UserRegistrationVC.swift
//  weApp
//
//  Created by Oliver Brehm on 14.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class UserRegistrationVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mailTextField: UITextField!
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
    
    func sendLoginRequest(_ nvc: RegistrationNVC)
    {
        self.stackView.isHidden = true
        self.activityIndicator.startAnimating()
        
        // default enable auto login
        UserDefaults.standard.set(true, forKey: "autologinEnabled")
        UserDefaults.standard.set(nvc.mail, forKey: "autologinmail")
        UserDefaults.standard.set(nvc.password, forKey: "autologinPassword")
        print("autologin enabled")
        
        User.login(nvc.mail, password: nvc.password) { (success: Bool) in
            self.dismiss(animated: true)
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.password1TextField.resignFirstResponder()
        self.password2TextField.resignFirstResponder()
        self.mailTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField === self.mailTextField) {
            self.password1TextField.becomeFirstResponder()
        } else if(textField === self.password1TextField) {
            self.password2TextField.becomeFirstResponder()
        } else if(textField === self.password2TextField) {
            self.password2TextField.resignFirstResponder()
        }
        
        return true
    }
    
    func sendRegisterRequest(_ nvc: RegistrationNVC)
    {
        // TODO location, nationality, date of birth, date of immigration
        User.register(mail: nvc.mail, password: nvc.password, firstName: nvc.firstName, lastName: nvc.lastName, immigrant: nvc.userType, gender: nvc.gender, dateOfBirth: Date.distantPast, nationality: "", dateOfImmigration: Date.distantPast, locationLatitude: 0, locationLongitude: 0) { (success: Bool) in
        
            if(!success) {
                self.presentAlert("Register", message: "Error registering", cancelButtonTitle: "OK", animated: true)
            } else {
                self.presentAlert("Register", message: "Account successfully created", cancelButtonTitle: "Login", animated: true) { (UIAlertAction) in
                    self.sendLoginRequest(nvc)
                }
            }
        }
    }
    
    @IBAction func registerButtonClicked(_ sender: AnyObject) {
        if(self.mailTextField.text!.isEmpty || self.password1TextField.text!.isEmpty || self.password2TextField.text!.isEmpty) {
            self.presentAlert("Register", message: "Please enter mail adress and password", cancelButtonTitle: "OK", animated: true)
            return
        }
        
        if(password1TextField.text != password2TextField.text) {
            self.presentAlert("Register", message: "The passwords do not match", cancelButtonTitle: "OK", animated: true)
            self.password1TextField.text = ""
            self.password2TextField.text = ""
            return
        }
        
        if(!self.agreementSwitch.isOn) {
            self.presentAlert("Register", message: "Please agree to the license agreement", cancelButtonTitle: "OK", animated: true)
            return
        }
        
        if let nvc = self.parent as? RegistrationNVC {
            nvc.mail = self.mailTextField.text!
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
