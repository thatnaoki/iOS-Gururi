//
//  Invite.swift
//  Gururi
//
//  Created by Naoki Muroya on 2019/02/25.
//  Copyright © 2019 Gururi. All rights reserved.
//

import Foundation

class Invitation {
    
    var invitationId: String?
    var date: String?
    var time: String?
    var fromUid: String?
    var guestName: String?
    var people: String?
    var tel: String?
    var inviteFlag: Bool?
    var staffName: String?
    
    init(invitationId: String?, date: String?, time: String?, fromUid: String?, guestName: String?, people: String?, tel: String?, inviteFlag: Bool?, staffName: String?) {
        
        self.invitationId = invitationId
        self.date = date
        self.time = time
        self.fromUid = fromUid
        self.guestName = guestName
        self.people = people
        self.tel = tel
        self.inviteFlag = inviteFlag
        self.staffName = staffName
        
    }
    
}
