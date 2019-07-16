//
//  Payment.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 12/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import Foundation

class Payment {
    var amount = 0
    var reason = ""
    var iam = ""
    var time = 0
    required init(amount : Int , reason : String ,iam :String , time : Int) {
        self.amount = amount
        self.reason = reason
        self.iam = iam
        self.time = time
    }
}
