//
//  CreateJoinRequestVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 23.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class CreateJoinRequestVC: UIViewController {
    var invitation: Invitation?

    @IBOutlet weak var textField: UITextView!
    
    @IBOutlet weak var participantsSlider: UISlider!
    @IBOutlet weak var participantsLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func participantsSliderChanged(sender: UISlider) {
        self.participantsLabel.text = "\(Int(sender.value))"
    }

    @IBAction func sendButtonClicked(sender: UIButton) {
        if(invitation == nil || User.current == nil) {
            return
        }
        
        if(self.textField.text.isEmpty) {
            self.presentAlert("Send request", message: "Please enter a message", cancelButtonTitle: "OK", animated: true)
            return
        }
        
        self.activityIndicator.startAnimating()
        sender.hidden = true;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let success = self.invitation!.createJoinRequest(User.current!, numParticipants: Int(self.participantsSlider.value))
            
            dispatch_async(dispatch_get_main_queue()) {
                
                if(success) {
                    self.presentAlert("Send request", message: "Request successfully sent", cancelButtonTitle: "OK", animated: true, completion: {(UIAlertAction) in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                } else {
                    self.presentAlert("Send request", message: "Error sending request", cancelButtonTitle: "OK", animated: true)
                }
                
                self.activityIndicator.stopAnimating()
                sender.hidden = false
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
