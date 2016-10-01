//
//  InvitationDetailTVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 13.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class InvitationDetailTVC: UITableViewController {
    
    var invitation: Invitation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        if(self.invitation != nil) {
            self.title = invitation!.name
            
            self.invitation!.queryDetails() { (success: Bool) in
                if(!success) {
                    DispatchQueue.main.async {
                        self.presentAlert("Error loading invitation", message: "The invitation details could not be loaded", cancelButtonTitle: "OK", animated: true) { (alertAction: UIAlertAction?) in
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                self.invitation!.queryMessages() { (success : Bool) in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    self.invitation!.queryParticipants() { (success: Bool) in
                        
                        DispatchQueue.main.async {
                            if(self.invitation!.createdByUser(User.current)) {
                                let item = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(InvitationDetailTVC.editButtonClicked))
                                self.navigationItem.rightBarButtonItem = item
                                
                            } else { // TODO if not already tried to join (request sent) TODO if not already joined
                                let item = UIBarButtonItem(title: "Join", style: UIBarButtonItemStyle.plain, target: self, action: #selector(InvitationDetailTVC.joinButtonClicked))
                                self.navigationItem.rightBarButtonItem = item
                            }
                            
                            self.tableView.reloadData()
                            
                        }
                    }
                }
            }
        }
    }

    func editButtonClicked() {
        self.performSegue(withIdentifier: "editInvitation", sender: self)
    }
    
    func joinButtonClicked() {
        self.performSegue(withIdentifier: "joinInvitation", sender: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.invitation == nil) {
            return 0
        }
        
        switch(section) {
        case 0: return 2; // info: description, date
        case 1: return self.invitation!.messages == nil ? 1 : 1 + min(2, self.invitation!.messages!.count()); // messages: show all, second most recent, most recent
        case 2: return self.invitation!.participants.count;
        case 3: return 3; // address: city, street, location
        default:
            return 0;
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Info"
        case 1: return "Messages"
        case 2: return "Participants";
        case 3: return "Address";
        default: return nil;
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if(indexPath.section == 0) { // info
            cell = tableView.dequeueReusableCell(withIdentifier: "invitationInfoCell", for: indexPath as IndexPath)
            
            if(self.invitation == nil) {
                return cell
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
            
            var date = ""
            if(self.invitation!.date != nil) {
                date = dateFormatter.string(from: self.invitation!.date!)
            }
            
            switch(indexPath.row) {
            case 0:
                cell.textLabel?.text = "Description"
                cell.detailTextLabel?.text = self.invitation!.description
                break;
            case 1:
                cell.textLabel?.text = "Date"
                cell.detailTextLabel?.text = date
                break;
            default: break
            }
        } else if(indexPath.section == 1) { // messages
            switch(indexPath.row) {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "showMessagesCell", for: indexPath)
                
                break
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
                
                let messages = self.invitation!.messages!
                cell.textLabel?.text = messages.message(index: messages.count() - 1).text
                
                break
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
                
                let messages = self.invitation!.messages!
                cell.textLabel?.text = messages.message(index: messages.count() - 2).text
                
                break
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
                break
            }
        } else if (indexPath.section == 2) { // participants
            cell = tableView.dequeueReusableCell(withIdentifier: "participantCell", for: indexPath)
            
            let participant = self.invitation!.participants[indexPath.row]
            
            cell.textLabel?.text = participant.firstName
        } else { //if(indexPath.section == 3) { // address
            cell = tableView.dequeueReusableCell(withIdentifier: "invitationInfoCell", for: indexPath as IndexPath)

            var street = ""
            if(self.invitation!.locationStreet != nil && self.invitation!.locationStreetNumber != nil) {
                street = self.invitation!.locationStreet! + " \(self.invitation!.locationStreetNumber!)"
            }
            
            var location = ""
            if(self.invitation!.locationLatitude != nil && self.invitation!.locationLongitude != nil) {
                location = "(\(self.invitation!.locationLatitude!), \(self.invitation!.locationLongitude!))"
            }
            
            switch(indexPath.row) {
            case 0:
                cell.textLabel?.text = "City"
                cell.detailTextLabel?.text = self.invitation!.locationCity
                break;
            case 1:
                cell.textLabel?.text = "Street"
                cell.detailTextLabel?.text = street
                break;
            case 2:
                cell.textLabel?.text = "Location"
                cell.detailTextLabel?.text = location
                break;
            default: break
            }

        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 2) { // Participants
            // present user page
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserProfileTVC") as! UserProfileTVC
            vc.user = self.invitation?.participants[indexPath.row]
            self.navigationController?.show(vc, sender: nil)
        }
    }
    
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var destination : UIViewController? = segue.destination
        if(destination is UINavigationController) {
            destination = (destination as! UINavigationController).visibleViewController
        }
        
        if(destination is CreateInvitationTVC) {
            (destination as! CreateInvitationTVC).invitation = self.invitation
            (destination as! CreateInvitationTVC).invitationDetailTVC = self
        } else if(destination is CreateJoinRequestVC) {
            (destination as! CreateJoinRequestVC).invitation = self.invitation
        } else if(destination is InvitationMessageTVC) {
            (destination as! InvitationMessageTVC).invitation = self.invitation
        }
    }

}
