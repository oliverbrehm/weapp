//
//  InvitationMessageTVC.swift
//  weApp
//
//  Created by Oliver Brehm on 29.09.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class InvitationMessageTVC: UITableViewController, UITextViewDelegate {
    public var invitation : Invitation?
    
    fileprivate var stateCell : TableViewStateCell?
    fileprivate var editCell : MessageEditCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadMessages()
    }
    
    func loadMessages()
    {
        if(self.invitation != nil) {
            self.title = self.invitation!.name
            
            self.invitation!.queryMessages() { (success : Bool) in
                DispatchQueue.main.async {
                    if(success) {
                        self.tableView.reloadData()
                    } else {
                        self.presentAlert("Error", message: "Failed to load invitation messages", cancelButtonTitle: "OK", animated: true) { (Void) -> Void in
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
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
        if(section == 0) {
            if(self.invitation == nil) {
                return 0
            }
            return self.invitation!.messages!.count()
        } else if(section == 1) {
            return 1 // state cell (refresh)
        } else if(section == 2) {
            return 1 // edit cell
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(indexPath.section == 1) { // state cell -> refresh
            loadMessages()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0) { // message cells
            return 200.0
        } else if(indexPath.section == 1) {
            return 42.0 // refresh cell
        } else { // 2, edit cell
            return 200.0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) { // add invitation cell
            let message = self.invitation!.messages!.message(index: indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
            
            cell.authorLabel.text = message.owner.firstName + ":" // TODO ownerName is empty (-> server problem!)
            cell.messageTextField.text = message.text
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            
            cell.timestampLabel.text = dateFormatter.string(from: message.time)
            
            if(indexPath.row % 2 == 0) {
                cell.backgroundColor = UIColor.orange
            } else {
                cell.backgroundColor = UIColor.purple
            }
            
            return cell
        } else if(indexPath.section == 1) { //= state cell (refresh)
            if(self.stateCell == nil) {
                self.stateCell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath) as? TableViewStateCell
            }

            if(self.invitation != nil && self.invitation!.messages!.isEmpty()) {
                self.stateCell?.displayMessage(message: "No messages. Refresh...")
            } else {
                self.stateCell?.displayMessage(message: "Refresh...")
            }
            
            return self.stateCell!
        } else { // if(indexPath.section == 2) { // edit cell
            if(self.editCell == nil) {
                self.editCell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as? MessageEditCell
            }
            return self.editCell!
        }
    }
    @IBAction func sendMessageClicked(_ sender: AnyObject) {
        if(self.invitation != nil && User.current != nil && self.editCell != nil && !self.editCell!.textEdit.text.isEmpty) {
            self.invitation!.postMessage(user: User.current!, message: self.editCell!.textEdit.text) { (success : Bool) in
                DispatchQueue.main.async {
                    if(success) {
                        self.loadMessages()
                        if(self.editCell != nil) {
                            self.editCell!.textEdit.resignFirstResponder()
                            self.editCell!.textEdit.text = ""
                        }
                    } else {
                        self.presentAlert("Error", message: "Failed to create message", cancelButtonTitle: "OK", animated: true)
                    }
                }
            }
        }

    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if(self.editCell != nil) {
            self.editCell!.textEdit.resignFirstResponder()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // scroll up to make room for the keyboard
        let pointInTable = textView.superview!.convert(textView.frame.origin, to: self.tableView)
        var contentOffset = self.tableView.contentOffset
        contentOffset.y = (pointInTable.y - textView.superview!.frame.size.height)
        self.tableView.setContentOffset(contentOffset, animated: true)
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

    }
    
}

