//
//  InvitationTableViewCell.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/25.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit

class InvitationTableViewCell: UITableViewCell {
    
    // MARK: properties
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var invitation: Invitation? {
        didSet {
            guard let invitation = invitation else {return}
            self.guestNameLabel.text = "\(invitation.guestName!)様"
            self.peopleLabel.text = "\(invitation.people!)名"
            self.dateLabel.text = invitation.date
            self.timeLabel.text = invitation.time
        }
    }
}
