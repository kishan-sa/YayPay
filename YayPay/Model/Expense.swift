//
//  Expense.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 10/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import Foundation

class Expense{
    var category : String?
    var expense : String?
    var reason : String?
    init(category : String , expense : String , reason : String) {
        self.category = category
        self.expense = expense
        self.reason = reason
    }
}
