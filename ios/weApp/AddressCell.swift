//
//  AddressCell.swift
//  weApp
//
//  Created by sohrab on 24/10/16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import UIKit

class AddressCell: UITableViewCell {

    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationStreet: UILabel!
    @IBOutlet weak var locationCity: UILabel!
    @IBOutlet weak var locationZip: UILabel!
    @IBOutlet weak var locationCountry: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
