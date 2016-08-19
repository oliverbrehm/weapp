//
//  UserTypeSelectionVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 14.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class UserTypeSelectionVC: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var iAmLabel: UILabel!
    @IBOutlet weak var typeSelectionSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func typeSelectionSegmentControlValueChanged(sender: AnyObject) {
        if let segmentedControl = sender as? UISegmentedControl {
            if(segmentedControl.selectedSegmentIndex == 0) {
                // local
                self.infoLabel.text = "I want to meet immigrants"
                self.iAmLabel.text = "I am a..."
            } else {
                // immigrant
                self.infoLabel.text = "I want to meet locals"
                self.iAmLabel.text = "I am an..."
            }
        }
    }

    @IBAction func nextButtonClicked(sender: AnyObject) {
        if let nvc = self.parentViewController as? RegistrationNVC {
            nvc.userType = (self.typeSelectionSegmentedControl.selectedSegmentIndex == 0) ? true : false
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
