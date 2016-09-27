//
//  UserInvitationsTVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 23.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class UserInvitationsTVC: UITableViewController {
    fileprivate var invitations: [Invitation] = []
    fileprivate var participatingInvitations: [Invitation] = []
    fileprivate var joinRequests: [JoinRequest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }
    
    // TODO move to invitation -> getInvitations...
    fileprivate func sendInvitationListRequest(completion: @escaping (([Invitation]) -> Void))
    {
        let request = HTTPInvitationListRequest()
        
        let user = User.current
        if(user == nil) {
            completion([Invitation(invitationId: 0, name: "Error loading invitations...")])
            return
        }
        
        request.send(user!) { (success: Bool) in
            if(request.responseValue == false) {
                completion([Invitation(invitationId: 0, name: "Error loading invitations...")])
                return
            }
            
            var invitationList: [Invitation] = []
            for invitationHeader in request.invitations {
                let invitationId = Int(invitationHeader.id)!
                invitationList.append(Invitation(invitationId: invitationId, name: invitationHeader.name))
            }
            
            completion(invitationList)
        }
    }
    
    fileprivate func sendInvitationParticipatingListRequest(completion: @escaping (([Invitation]) -> Void))
    {
        let request = HTTPInvitationParticipatingListRequest()
        
        let user = User.current
        if(user == nil) {
            completion([Invitation(invitationId: 0, name: "Error loading invitations...")])
            return
        }
        
        request.send(user!) { (success: Bool) in
            if(request.responseValue == false) {
                completion([Invitation(invitationId: 0, name: "Error loading invitations...")])
                return
            }
            
            var invitationList: [Invitation] = []
            for invitationHeader in request.invitations {
                let invitationId = Int(invitationHeader.id)!
                invitationList.append(Invitation(invitationId: invitationId, name: invitationHeader.name))
            }
            
            completion(invitationList)
        }
    }
    
    fileprivate func sendJoinRequestListRequest(completion: @escaping (([JoinRequest]) -> Void))
    {
        let request = HTTPJoinRequestListRequest()
        
        let user = User.current
        if(user == nil) {
            completion([JoinRequest(requestId: 0, userId: 0, invitationId: 0, numParticipants: 0, maxParticipants: 0, invitationName: "Error loading Requests")])
            return
        }
        
        request.send(user!) { (success: Bool) in
        
            if(request.responseValue == false) {
                completion([JoinRequest(requestId: 0, userId: 0, invitationId: 0, numParticipants: 0, maxParticipants: 0, invitationName: "Error loading Requests")])
                return
            }
            
            completion(request.joinRequests)
        }
    }
    
    fileprivate func loadInvitations()
    {
        invitations.removeAll()
        invitations.append(Invitation(invitationId: 0, name: "Loading..."))
        self.tableView.reloadData()
        
        self.sendInvitationListRequest { (invitations: [Invitation]) in
            self.invitations = invitations
            
            self.sendJoinRequestListRequest { (joinRequests: [JoinRequest]) in
                self.joinRequests = joinRequests
            }
            self.sendInvitationParticipatingListRequest { (invitations: [Invitation]) in
                self.participatingInvitations = invitations
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.invitations = []
        self.joinRequests = []
        self.participatingInvitations = []
        self.tableView.reloadData()
        self.loadInvitations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return ((self.joinRequests.count + self.invitations.count) == 0) ? 1 : 0
        case 1: return self.joinRequests.count
        case 2: return self.invitations.count
        case 3: return self.participatingInvitations.count
        default: return 0;
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "Join requests"
        case 2: return "My invitations"
        case 3: return "Participating invitations"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if((indexPath as NSIndexPath).section == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        } else if((indexPath as NSIndexPath).section == 1) {
            cell = tableView.dequeueReusableCell(withIdentifier: "joinRequestCell", for: indexPath)
            let request = self.joinRequests[(indexPath as NSIndexPath).row]
            if(User.current != nil) {
                if(User.current!.id == request.userId) {
                    cell.backgroundColor = UIColor.green.withAlphaComponent(0.4)
                } else {
                    cell.backgroundColor = UIColor.orange.withAlphaComponent(0.4)
                }
            }
            cell.textLabel?.text = "\(request.invitationName) (\(request.numParticipants) participants)"
        } else if((indexPath as NSIndexPath).section == 2) {
            cell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath)
            cell.textLabel?.text = invitations[(indexPath as NSIndexPath).row].name
        } else { // 3
            cell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath)
            cell.textLabel?.text = participatingInvitations[(indexPath as NSIndexPath).row].name
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
            if(selectedSection == 2) { // my invitations
                invitationDetailTVC.invitation = self.invitations[selectedRow]
            } else { // 3, my participations
                invitationDetailTVC.invitation = self.participatingInvitations[selectedRow]
            }
        } else if(segue.destination is JoinRequestTVC) {
            let joinRequestTVC = segue.destination as! JoinRequestTVC
            joinRequestTVC.joinRequest = self.joinRequests[selectedRow]
        }
    }
}
