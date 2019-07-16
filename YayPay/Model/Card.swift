//
//  Card.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 10/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import Foundation

class Card {
    var accountnumber : String?
    var balance : String?
    init(accountnumber : String , balance : String) {
        self.accountnumber = accountnumber
        self.balance = balance
    }
    func mask(){
        var acountstring = "\(accountnumber!)"
        print(acountstring)
        let start = acountstring.index(acountstring.startIndex, offsetBy: 4);
        let end = acountstring.index(acountstring.startIndex, offsetBy: 4 + 8);
        acountstring.replaceSubrange(start..<end, with: "xxxxxxxx")
        print(acountstring)
        
        self.accountnumber = acountstring
    
    }
}
