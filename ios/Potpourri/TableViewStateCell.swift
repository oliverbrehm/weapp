//
//  InvitationLoadingCell.swift
//  Potpourri
//
//  Created by Oliver Brehm on 28.09.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import UIKit

class TableViewStateCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setBusy()
    {
        self.activityIndicator.startAnimating()
        self.messageLabel.isHidden = true
    }
    
    func displayMessage(message: String)
    {
        self.activityIndicator.stopAnimating()
        self.messageLabel.isHidden = false
        self.messageLabel.text = message
    }
    
}
