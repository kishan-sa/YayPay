//
//  Card.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 10/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import Foundation

class Card {
    var accountnumber : Int?
    var balance : Int?
    init(accountnumber : Int , balance : Int) {
        self.accountnumber = accountnumber
        self.balance = balance
    }
}
