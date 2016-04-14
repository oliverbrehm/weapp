//
//  UserPersonalInfoVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 14.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class UserPersonalInfoVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ageSliderValueChanged(sender: AnyObject) {
        if let slider = sender as? UISlider {
            self.ageLabel.text = "\(Int(slider.value))"
        }
    }
    
    @IBAction func nextButtonClicked(sender: AnyObject) {
        if(self.firstNameTextField.text!.isEmpty || self.lastNameTextField.text!.isEmpty) {
            let alert = UIAlertController(title: "Register", message: "Please enter a first and a last name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if let nvc = self.parentViewController as? RegistrationNVC {
            nvc.firstName = self.firstNameTextField.text!
            nvc.lastName = self.lastNameTextField.text!
            nvc.age = Int(self.ageSlider.value)
            nvc.gender = (self.genderSegmentedControl.selectedSegmentIndex == 0) ? true : false
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.firstNameTextField.resignFirstResponder()
        self.lastNameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField === self.firstNameTextField) {
            self.lastNameTextField.becomeFirstResponder()
        } else if(textField === self.lastNameTextField) {
            self.lastNameTextField.resignFirstResponder()
        }
        
        return true
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
