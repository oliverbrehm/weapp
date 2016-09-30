//
//  UserProfileTVC.swift
//  integrationsproject-incubateion
//
//  Created by Oliver Brehm on 10.04.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import UIKit

class UserProfileTVC: UITableViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var sessionIdLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var dateOfImmigrationLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var locationLatitudeLabel: UILabel!
    @IBOutlet weak var locationLongitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    func updateUI()
    {
        if let user = User.current {
            let sqlDateFormatter = DateFormatter()
            sqlDateFormatter.dateFormat = "yyyy-MM-dd"
            
            self.title = user.firstName! + " " + user.lastName!
            self.emailLabel.text = user.email
            self.sessionIdLabel.text = user.sessionId
            self.userIdLabel.text = "\(user.id)"
            self.userTypeLabel.text = user.immigrant! ? "Immigrant" : "Local"
            self.genderLabel.text = user.gender! ? "Male" : "Female"
            self.dateOfBirthLabel.text  = sqlDateFormatter.string(from: user.dateOfBirth!)
            self.dateOfImmigrationLabel.text  = sqlDateFormatter.string(from: user.dateOfImmigration!)
            self.nationalityLabel.text = user.nationality
            self.locationLatitudeLabel.text = "\(user.locationLatitude!)"
            self.locationLongitudeLabel.text = "\(user.locationLongitude!)"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        
        if(cell?.reuseIdentifier == "logoutCell") {
            User.logout() { (success: Bool) in
                if(!success) {
                    self.presentAlert("Logout", message: "Unable to logout user", cancelButtonTitle: "OK", animated: true)
                     return
                } else {
                    // if logged out
                    User.current = nil
                    
                    // -> UINavigationController -> MainTBC
                    let mainTBC = self.parent?.parent as? MainTBC
                    mainTBC?.performSegue(withIdentifier: "showLogin", sender: self)
                    mainTBC?.clearData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
