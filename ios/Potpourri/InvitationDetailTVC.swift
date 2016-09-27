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
    var participants: [Participant] = []
    
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
        if(self.invitation != nil) {
            self.title = invitation!.name
            
            self.invitation!.queryDetails() { (success: Bool) in
                if(!success) {
                    return
                }
                
                self.invitation!.getParticipants() { (participants: [Participant]) in
                
                    if(self.invitation == nil) {
                        return
                    }
                    
                    self.participants = participants
                    
                    self.participants.insert(Participant(userId: self.invitation!.ownerId!, firstName: self.invitation!.ownerFirstName! + " (owner)", numPersons: 1), at: 0)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                        if(self.invitation!.createdByUser(User.current)) {
                            let item = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(InvitationDetailTVC.editButtonClicked))
                            self.navigationItem.rightBarButtonItem = item
                            
                        } else { // TODO if not already tried to join (request sent) TODO if not already joined
                            let item = UIBarButtonItem(title: "Join", style: UIBarButtonItemStyle.plain, target: self, action: #selector(InvitationDetailTVC.joinButtonClicked))
                            self.navigationItem.rightBarButtonItem = item
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return self.participants.count;
        default: // 1
            return 5;
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Participants";
        case 1: return "Info";
        default: return nil;
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if(indexPath.section == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "participantCell", for: indexPath)

            cell.textLabel?.text = participants[indexPath.row].firstName + "(\(participants[indexPath.row].numPersons))"
        } else { // 1
            cell = tableView.dequeueReusableCell(withIdentifier: "invitationInfoCell", for: indexPath as IndexPath)
            
            if(self.invitation == nil) {
                return cell
            }
            
            let i = self.invitation!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
            
            var date = ""
            if(i.date != nil) {
                date = dateFormatter.string(from: i.date!)
            }
            
            var street = ""
            if(i.locationStreet != nil && i.locationStreetNumber != nil) {
                street = i.locationStreet! + "\(i.locationStreetNumber!)"
            }
            
            var location = ""
            if(i.locationLatitude != nil && i.locationLongitude != nil) {
                location = "(\(i.locationLatitude!), \(i.locationLongitude!))"
            }
            
            switch(indexPath.row) {
            case 0:
                cell.textLabel?.text = "Description"
                cell.detailTextLabel?.text = i.description
                break;
            case 1:
                cell.textLabel?.text = "Date"
                cell.detailTextLabel?.text = date
                break;
            case 2:
                cell.textLabel?.text = "City"
                cell.detailTextLabel?.text = i.locationCity
                break;
            case 3:
                cell.textLabel?.text = "Street"
                cell.detailTextLabel?.text = street
                break;
            case 4:
                cell.textLabel?.text = "Location"
                cell.detailTextLabel?.text = location
                break;
            default: break
            }
        }

        return cell
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
        if let vc = segue.destination as? CreateInvitationTVC {
            vc.invitation = self.invitation
        } else if let vc = segue.destination as? CreateJoinRequestVC {
            vc.invitation = self.invitation
        }
    }

}
