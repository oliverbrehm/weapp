//
//  InvitationListTVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 13.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class InvitationListTVC: UITableViewController {
    fileprivate var invitations = InvitationList(city: "", sortingCriteria: .Date, owner: nil, participatingUser: nil)
    
    fileprivate var stateCell : TableViewStateCell?
    
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
    }
    
    func clearData()
    {
        self.invitations = InvitationList(city: "", sortingCriteria: .Date, owner: nil, participatingUser: nil)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadInvitations()
    }

    func loadInvitations()
    {
        if(!User.loggedIn()) {
            self.stateCell?.displayMessage(message: "Logging in...")
            return
        }
        
        if(self.invitations.isEmpty()) {
            self.stateCell?.setBusy()
            self.invitations.fetch(number: 20) { (success) in
                if(!success) {
                    self.stateCell?.displayMessage(message: "Error loading invitations")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    func userDidLogin()
    {
        self.loadInvitations()
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if(self.invitations.isEmpty()) {
            return 1 // state cell
        }
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.invitations.isEmpty()) {
            return 1 // state cell
        }
        
        if(section == 0) {
            return 1 // add invitation cell
        } else if(section == 1) {
            return self.invitations.count()
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(self.invitations.isEmpty()) {
            if(self.stateCell == nil) {
                self.stateCell = tableView.dequeueReusableCell(withIdentifier: "invitationLoadingCell", for: indexPath) as? TableViewStateCell
                self.loadInvitations()
            }
            
            return self.stateCell!
        }
        
        if(indexPath.section == 0) { // add invitation cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "addInvitationCell", for: indexPath)
            
            return cell
        } else { // invitation cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath) as! InvitationCell
            
            cell.titleLabel.text = invitations.invitation(index: (indexPath as NSIndexPath).row).name
            
            return cell
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
        if(segue.identifier == "invitationDetail" && segue.destination is InvitationDetailTVC) {
            let selectedRow = (self.tableView.indexPathForSelectedRow! as NSIndexPath).row
            let invitationDetailTVC = segue.destination as! InvitationDetailTVC
            invitationDetailTVC.invitation = self.invitations.invitation(index: selectedRow)
        }
    }

}
