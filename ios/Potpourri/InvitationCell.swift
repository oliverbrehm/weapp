//
//  InvitationCell.swift
//  Potpourri
//
//  Created by Oliver Brehm on 28.09.16.
//  Copyright © 2016 Oliver Brehm. All rights reserved.
//

import Foundation
import UIKit

class InvitationCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
        
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
