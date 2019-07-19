//
//  Payment.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 12/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import Foundation

class Payment : Hashable{
    var type = ""
    var amount = 0
    var reason = ""
    var iam = ""
    var time = 0
    var massage = ""
    init() {
    }
    init(massage : String) {
        self.massage = massage
    }
    init(amount : Int , reason : String ,iam :String , time : Int) {
        self.amount = amount
        self.reason = reason
        self.iam = iam
        self.time = time
    }
    var hashValue: Int {
        return self.time
    }
    
    static func == (lhs: Payment, rhs: Payment) -> Bool {
        return lhs.time == rhs.time
    }
}
