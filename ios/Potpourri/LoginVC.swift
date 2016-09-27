//
//  LoginVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 10.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var autologinSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField === emailTextField) {
            passwordTextField.becomeFirstResponder()
        } else if(textField == passwordTextField) {
            self.loginButtonPressed(self.loginButton)
        }
        return true
    }
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        
        let loginButton = sender as! UIButton
        
        if(email.isEmpty || password.isEmpty) {
            self.presentAlert("Login", message: "Please enter your email adress and password", cancelButtonTitle: "OK", animated: true)
        } else {
            self.activityIndicator.startAnimating()
            loginButton.isHidden = true;
            
            UserDefaults.standard.set(self.autologinSwitch.isOn, forKey: "autologinEnabled")
            
            if(self.autologinSwitch.isOn) {
                UserDefaults.standard.set(email, forKey: "autologinEmail")
                UserDefaults.standard.set(password, forKey: "autologinPassword")
                print("autologin enabled")
            }
            
            User.login(email, password: password) { (success: Bool) in
                if(!success) {
                    self.presentAlert("Login failed", message: "Invalid email adress or password", cancelButtonTitle: "OK", animated: true)
                } else {
                    self.dismiss(animated: true)
                }
                
                self.activityIndicator.stopAnimating()
                loginButton.isHidden = false
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
