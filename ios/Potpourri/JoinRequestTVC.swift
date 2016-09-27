//
//  JoinRequestTVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 23.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class JoinRequestTVC: UITableViewController {
    
    var joinRequest: JoinRequest?
    
    var participantsLabelText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.joinRequest == nil) {
            return
        }
        
        self.title = self.joinRequest!.invitationName
        self.participantsLabelText = "\(self.joinRequest!.numParticipants) new participants (\(self.joinRequest!.maxParticipants) total)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.joinRequest == nil || User.current == nil) {
            return 1;
        }
        
        if(self.joinRequest!.userId == User.current!.id) {
            return 1;
        }
        
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "participantsCell", for: indexPath)
            cell.textLabel?.text = self.participantsLabelText
            break;
        default: // 1
            cell = tableView.dequeueReusableCell(withIdentifier: "reactionCell", for: indexPath)
            break;
        }
        
        return cell
    }
    
    @IBAction func acceptButtonClicked(_ sender: UIButton) {
        sender.isHidden = true;
        
        let request = HTTPJoinRequestAccept()
        request.send(self.joinRequest!.requestId) { (success: Bool) in
            if(!request.responseValue) {
                self.presentAlert("Accepting failed", message: "Please try again", cancelButtonTitle: "OK", animated: true)
            } else {
                self.presentAlert("Join Request", message: "Successfully accepted request", cancelButtonTitle: "OK", animated: true) {(UIAlertView) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            sender.isHidden = false
        }
    }
    
    @IBAction func rejectButtonClicked(_ sender: UIButton) {
        sender.isHidden = true;
        
        let request = HTTPJoinRequestReject()
        request.send(self.joinRequest!.requestId) { (success: Bool) in
            if(!request.responseValue) {
                self.presentAlert("Rejecting failed", message: "Please try again", cancelButtonTitle: "OK", animated: true)
            } else {
                self.presentAlert("Join Request", message: "Successfully rejected request", cancelButtonTitle: "OK", animated: true) {(UIAlertView) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            sender.isHidden = false
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
