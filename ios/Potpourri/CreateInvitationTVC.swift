//
//  CreateInvitationTVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 22.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class CreateInvitationTVC: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var numberOfGuestsLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var streetNumberTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var numberOfGuestsSlider: UISlider!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var createInvitationButton: UIButton!
    
    var city = ""
    var postalCode = ""
    
    var invitation: Invitation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // if my invitation
        if(self.invitation != nil) {
            self.createInvitationButton.isHidden = true
            self.deleteButton.isHidden = false
            
            let invitation = self.invitation!

            // display invitation details
            self.titleTextField.text = invitation.name
            self.descriptionTextView.text = invitation.description
            self.numberOfGuestsSlider.value = Float(invitation.maxParticipants!)
            self.datePicker.date = invitation.date!
            self.cityLabel.text = invitation.locationCity
            self.streetTextField.text = invitation.locationStreet
            self.streetNumberTextField.text = String(describing: invitation.locationStreetNumber)
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.streetTextField.resignFirstResponder()
        self.streetNumberTextField.resignFirstResponder()
        self.titleTextField.resignFirstResponder()
        self.descriptionTextView.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nuberOfGuestsSliderChanged(_ sender: AnyObject) {
        if let slider = sender as? UISlider {
            self.numberOfGuestsLabel.text = "\(Int(slider.value))"
        }
    }
    
    @IBAction func createInvitationClicked(_ sender: UIButton) {
        // TODO resignFirstResponder()
        
        let name = self.titleTextField.text!
        let detailedDescription = self.descriptionTextView.text!
        let maxParticipants = Int(self.numberOfGuestsSlider.value)
        let date = self.datePicker.date
        let city = self.cityLabel.text!
        let street = self.streetTextField.text!
        let streetNumberOpt = Int(self.streetNumberTextField.text!)
        let streetNumber = streetNumberOpt == nil ? 0 : streetNumberOpt!
        
        if(name.isEmpty) {
            self.presentAlert("Create invitation", message: "Please enter a title", cancelButtonTitle: "OK", animated: true)
            return
        }
        
        if(city.isEmpty) {
            self.presentAlert("Create invitation", message: "Please enter a city", cancelButtonTitle: "OK", animated: true)
            return
        }
        
        if(street.isEmpty || streetNumberOpt == nil) {
            self.presentAlert("Create invitation", message: "Please enter street name and number", cancelButtonTitle: "OK", animated: true)
            return
        }
        
        if(detailedDescription.isEmpty) {
            self.presentAlert("Create invitation", message: "Please enter a description", cancelButtonTitle: "OK", animated: true)
            return
        }
        
        self.activityIndicator.startAnimating()
        sender.isHidden = true;
        
        Invitation.create(name, detailedDescription: detailedDescription, maxParticipants: maxParticipants, nsDate: date, locationCity: city, locationStreet: street, locationStreetNumber: streetNumber, locationLatitude: 7, locationLongitude: 8) { (success: Bool) in
            
            self.activityIndicator.stopAnimating()
            sender.isHidden = false
            
            if(!success) {
                self.presentAlert("Creating failed", message: "Error creating the invitation", cancelButtonTitle: "OK", animated: true)
            } else {
                self.presentAlert("Creation succeeded", message: "The invitation \(name) was successfully created", cancelButtonTitle: "OK", animated: true) { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func deleteInvitationClicked(_ sender: UIButton) {
        print("delete")
    }
    
    @IBAction func saveButtonClicked(_ sender: AnyObject) {
        print("save")
    }
    
    @IBAction func cancelButtonClicked(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true)
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
