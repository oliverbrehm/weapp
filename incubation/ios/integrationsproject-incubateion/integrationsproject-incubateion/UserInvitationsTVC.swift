//
//  UserInvitationsTVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 23.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class UserInvitationsTVC: UITableViewController {
    private var invitations: [Invitation] = []
    private var joinRequests: [JoinRequest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }
    
    private func sendInvitationListRequest() -> [Invitation]
    {
        let request = HTTPInvitationListRequest()
        
        let user = User.current
        if(user == nil) {
            return []
        }
        
        request.send(user!)
        
        if(request.responseValue == false) {
            return [Invitation(invitationId: 0, name: "Error loading invitations...")]
        }
        
        var invitationList: [Invitation] = []
        for invitationHeader in request.invitations {
            let invitationId = Int(invitationHeader.id)!
            invitationList.append(Invitation(invitationId: invitationId, name: invitationHeader.name))
        }
        
        return invitationList
    }
    
    private func sendJoinRequestListRequest() -> [JoinRequest]
    {
        let request = HTTPJoinRequestListRequest()
        
        let user = User.current
        if(user == nil) {
            return []
        }
        
        request.send(user!)
        
        if(request.responseValue == false) {
            return [JoinRequest(requestId: 0, userId: 0, invitationId: 0, numParticipants: 0, maxParticipants: 0, invitationName: "Error loading Requests")]
        }
        
        return request.joinRequests
    }
    
    private func loadInvitations()
    {
        invitations.removeAll()
        invitations.append(Invitation(invitationId: 0, name: "Loading..."))
        self.tableView.reloadData()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            self.invitations = self.sendInvitationListRequest();
            self.joinRequests = self.sendJoinRequestListRequest();
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.invitations = []
        self.joinRequests = []
        self.tableView.reloadData()
        self.loadInvitations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return ((self.joinRequests.count + self.invitations.count) == 0) ? 1 : 0
        case 1: return self.joinRequests.count
        case 2: return self.invitations.count
        default: return 0;
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "Join requests"
        case 2: return "My invitations"
        default: return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if(indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath)
        } else if(indexPath.section == 1) {
            cell = tableView.dequeueReusableCellWithIdentifier("joinRequestCell", forIndexPath: indexPath)
            let request = self.joinRequests[indexPath.row]
            if(User.current != nil) {
                if(User.current!.id == request.userId) {
                    cell.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.4)
                } else {
                    cell.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.4)
                }
            }
            cell.textLabel?.text = "\(request.invitationName) (\(request.numParticipants) participants)"
        } else { // 1
            cell = tableView.dequeueReusableCellWithIdentifier("invitationCell", forIndexPath: indexPath)
            cell.textLabel?.text = invitations[indexPath.row].name
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedRow = self.tableView.indexPathForSelectedRow!.row

        if(segue.identifier == "invitationDetail" && segue.destinationViewController is InvitationDetailTVC) {
            let invitationDetailTVC = segue.destinationViewController as! InvitationDetailTVC
            invitationDetailTVC.invitation = self.invitations[selectedRow]
        } else if(segue.destinationViewController is JoinRequestTVC) {
            let joinRequestTVC = segue.destinationViewController as! JoinRequestTVC
            joinRequestTVC.joinRequest = self.joinRequests[selectedRow]
        }
    }
}
