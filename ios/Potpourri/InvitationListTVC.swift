//
//  InvitationListTVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 13.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class InvitationListTVC: UITableViewController {
    fileprivate var invitations: [Invitation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        

    }
    
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

    fileprivate func loadInvitations()
    {
        invitations.removeAll()
        invitations.append(Invitation(invitationId: 0, name: "Loading..."))
        self.tableView.reloadData()
        
        self.sendInvitationListRequest() { (invitations: [Invitation]) in
            self.invitations = invitations
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.invitations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath)

        cell.textLabel?.text = invitations[(indexPath as NSIndexPath).row].name

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
        if(segue.identifier == "invitationDetail" && segue.destination is InvitationDetailTVC) {
            let selectedRow = (self.tableView.indexPathForSelectedRow! as NSIndexPath).row
            let invitationDetailTVC = segue.destination as! InvitationDetailTVC
            invitationDetailTVC.invitation = self.invitations[selectedRow]
        }
    }

}
