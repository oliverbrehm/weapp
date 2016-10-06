//
//  UserInvitationsTVC.swift
//  weApp
//
//  Created by Oliver Brehm on 23.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class UserInvitationsTVC: UITableViewController {
    
    var invitationStateCell : TableViewStateCell?
    var participatingInvitationStateCell : TableViewStateCell?
    var joinRequestStateCell : TableViewStateCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.orange
        self.refreshControl?.tintColor = UIColor.white
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        self.refreshControl?.addTarget(self, action: #selector(InvitationListTVC.refresh(_:)), for: UIControlEvents.valueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refresh(_ sender:AnyObject)
    {
        self.loadInvitations()
        self.refreshControl?.endRefreshing()
    }
  
    fileprivate func loadInvitations()
    {
        if let user = User.current {
            // load user invitations
            self.invitationStateCell?.setBusy()
            user.queryInvitations() { (success: Bool) in
                if(!success) {
                    self.invitationStateCell?.displayMessage(message: "Error loading invitations")
                } else if(user.invitations!.isEmpty()) { // success but nothing to display
                    self.invitationStateCell?.displayMessage(message: "No invitations")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            // load user join requests
            self.joinRequestStateCell?.setBusy()
            user.queryJoinRequests() { (success: Bool) in
                if(!success) {
                    self.joinRequestStateCell?.displayMessage(message: "Error loading join requests")
                } else if(user.joinRequests!.isEmpty()) {
                    self.joinRequestStateCell?.displayMessage(message: "No join requests")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            // load user participations
            self.participatingInvitationStateCell?.setBusy()
            user.queryParticipations() { (success: Bool) in
                if(!success) {
                    self.participatingInvitationStateCell?.displayMessage(message: "Error loading invitations")
                } else if(user.participations!.isEmpty()) {
                    self.participatingInvitationStateCell?.displayMessage(message: "No invitations")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadInvitations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(User.current == nil) {
            return 1
        }
        
        let user = User.current!
        
        switch(section) {
        case 0: return (user.joinRequests == nil || user.joinRequests!.isEmpty() ? 1 : user.joinRequests!.count())
        case 1: return (user.invitations == nil || user.invitations!.isEmpty() ? 1 : user.invitations!.count())
        case 2: return (user.participations == nil || user.participations!.isEmpty() ? 1 : user.participations!.count())
        default: return 1;
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Join requests"
        case 1: return "My invitations"
        case 2: return "Participating invitations"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(User.current == nil) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! TableViewStateCell
            cell.displayMessage(message: "User not logged in...")
            return cell
        }
        
        let user = User.current!
        
        let cell: UITableViewCell
        
        switch(indexPath.section) {
        case 0:
            if(user.joinRequests!.isEmpty()) {
                if(self.joinRequestStateCell == nil) {
                    self.joinRequestStateCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as? TableViewStateCell
                }
                cell = self.joinRequestStateCell!
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "joinRequestCell", for: indexPath)
                let request = user.joinRequests!.joinRequest(index:(indexPath as NSIndexPath).row)
                if(User.current != nil) {
                    if(User.current!.id == request.user.id) {
                        cell.backgroundColor = UIColor.green.withAlphaComponent(0.4)
                    } else {
                        cell.backgroundColor = UIColor.orange.withAlphaComponent(0.4)
                    }
                }
                cell.textLabel?.text = "\(request.invitation.name) (\(request.numParticipants) participants)"
            }
            
            break
        case 1:
            if(user.invitations!.isEmpty()) {
                if(self.invitationStateCell == nil) {
                    self.invitationStateCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as? TableViewStateCell
                }
                cell = self.invitationStateCell!
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath)
                cell.textLabel?.text = user.invitations!.invitation(index: (indexPath as NSIndexPath).row).name
            }
            
            break
        case 2:
            if(user.participations!.isEmpty()) {
                if(self.participatingInvitationStateCell == nil) {
                    self.participatingInvitationStateCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as? TableViewStateCell
                }
                cell = self.participatingInvitationStateCell!
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath)
                cell.textLabel?.text = user.participations!.invitation(index: (indexPath as NSIndexPath).row).name
            }
            
            break
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) // TODO random beahaviour
            break
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(User.current == nil) {
            return
        }
        
        let user = User.current!
        
        let selectedSection = (self.tableView.indexPathForSelectedRow! as NSIndexPath).section
        let selectedRow = (self.tableView.indexPathForSelectedRow! as NSIndexPath).row

        if(segue.identifier == "invitationDetail" && segue.destination is InvitationDetailTVC) {
            let invitationDetailTVC = segue.destination as! InvitationDetailTVC
            if(selectedSection == 1) { // my invitations
                invitationDetailTVC.invitation = user.invitations!.invitation(index: selectedRow)
            } else { // 2, my participations
                invitationDetailTVC.invitation = user.participations!.invitation(index: selectedRow)
            }
        } else if(segue.destination is JoinRequestTVC) {
            let joinRequestTVC = segue.destination as! JoinRequestTVC
            joinRequestTVC.joinRequest = user.joinRequests!.joinRequest(index: selectedRow)
        }
    }
}
