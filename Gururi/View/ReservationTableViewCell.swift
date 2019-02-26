//
//  ReservationTableViewCell.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/26.
//  Copyright © 2019 Gururi. All rights reserved.
//

import UIKit

class ReservationTableViewCell: UITableViewCell {

    // MARK: properties
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var reservation: Invitation? {
        didSet {
            guard let invitation = reservation else {return}
            self.guestNameLabel.text = "\(invitation.guestName!)様"
            self.peopleLabel.text = "\(invitation.people!)名"
            self.dateLabel.text = invitation.date
            self.timeLabel.text = invitation.time
            guard let people = Int(invitation.people!) else {return}
            self.priceLabel.text = "\(people * 300)円 ＞"
        }
    }
    
    
    
}
