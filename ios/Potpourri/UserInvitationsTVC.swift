//
//  UserInvitationsTVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 23.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class UserInvitationsTVC: UITableViewController {
    fileprivate var invitations : InvitationList?
    fileprivate var participatingInvitations : InvitationList?
    fileprivate var joinRequests : JoinRequestList?
    
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
        self.clearData()
        self.loadInvitations()
        
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing()
    }
    
    func clearData()
    {
        self.invitations = nil
        self.participatingInvitations = nil
        self.joinRequests = nil
    }
    
    fileprivate func loadInvitations()
    {
        if(self.invitations == nil) {
            self.invitations = InvitationList(city: "", sortingCriteria: .Date, owner: User.current, participatingUser: nil)
        }
        
        if(self.participatingInvitations == nil) {
            self.participatingInvitations = InvitationList(city: "", sortingCriteria: .Date, owner: nil, participatingUser: User.current)
        }
        
        if(self.joinRequests == nil) {
            self.joinRequests = JoinRequestList()
        }
        
        self.tableView.reloadData()
        
        if(self.invitations!.isEmpty()) {
            self.invitationStateCell?.setBusy()
            
            self.invitations!.fetch(number: 100) { (success: Bool) in
                if(!success) {
                    self.invitationStateCell?.displayMessage(message: "Error loading invitations")
                } else if(self.invitations!.isEmpty()) { // success but nothing to display
                    self.invitationStateCell?.displayMessage(message: "No invitations")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        if(self.joinRequests!.isEmpty()) {
            self.joinRequestStateCell?.setBusy()
            
            self.joinRequests!.fetch(max: 100) { (success: Bool) in
                if(!success) {
                    self.joinRequestStateCell?.displayMessage(message: "Error loading join requests")
                } else if(self.joinRequests!.isEmpty()) {
                    self.joinRequestStateCell?.displayMessage(message: "No join requests")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        if(self.participatingInvitations!.isEmpty()) {
            self.participatingInvitationStateCell?.setBusy()
            
            self.participatingInvitations!.fetch(number: 100) { (success: Bool) in
                if(!success) {
                    self.participatingInvitationStateCell?.displayMessage(message: "Error loading invitations")
                } else if(self.participatingInvitations!.isEmpty()) {
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
        switch(section) {
        case 0: return (self.joinRequests!.isEmpty() ? 1 : self.joinRequests!.count())
        case 1: return (self.invitations!.isEmpty() ? 1 : self.invitations!.count())
        case 2: return (self.participatingInvitations!.isEmpty() ? 1 : self.participatingInvitations!.count())
        default: return 0;
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
        let cell: UITableViewCell
        
        switch(indexPath.section) {
        case 0:
            if(self.joinRequests!.isEmpty()) {
                if(self.joinRequestStateCell == nil) {
                    self.joinRequestStateCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as? TableViewStateCell
                }
                cell = self.joinRequestStateCell!
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "joinRequestCell", for: indexPath)
                let request = self.joinRequests!.joinRequest(index:(indexPath as NSIndexPath).row)
                if(User.current != nil) {
                    if(User.current!.id == request.userId) {
                        cell.backgroundColor = UIColor.green.withAlphaComponent(0.4)
                    } else {
                        cell.backgroundColor = UIColor.orange.withAlphaComponent(0.4)
                    }
                }
                cell.textLabel?.text = "\(request.invitationName) (\(request.numParticipants) participants)"
            }
            
            break
        case 1:
            if(self.invitations!.isEmpty()) {
                if(self.invitationStateCell == nil) {
                    self.invitationStateCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as? TableViewStateCell
                }
                cell = self.invitationStateCell!
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath)
                cell.textLabel?.text = invitations!.invitation(index: (indexPath as NSIndexPath).row).name
            }
            
            break
        case 2:
            if(self.participatingInvitations!.isEmpty()) {
                if(self.participatingInvitationStateCell == nil) {
                    self.participatingInvitationStateCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as? TableViewStateCell
                }
                cell = self.participatingInvitationStateCell!
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath)
                cell.textLabel?.text = participatingInvitations!.invitation(index: (indexPath as NSIndexPath).row).name
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
        let selectedSection = (self.tableView.indexPathForSelectedRow! as NSIndexPath).section
        let selectedRow = (self.tableView.indexPathForSelectedRow! as NSIndexPath).row

        if(segue.identifier == "invitationDetail" && segue.destination is InvitationDetailTVC) {
            let invitationDetailTVC = segue.destination as! InvitationDetailTVC
            if(selectedSection == 1) { // my invitations
                invitationDetailTVC.invitation = self.invitations!.invitation(index: selectedRow)
            } else { // 2, my participations
                invitationDetailTVC.invitation = self.participatingInvitations!.invitation(index: selectedRow)
            }
        } else if(segue.destination is JoinRequestTVC) {
            let joinRequestTVC = segue.destination as! JoinRequestTVC
            joinRequestTVC.joinRequest = self.joinRequests!.joinRequest(index: selectedRow)
        }
    }
}
