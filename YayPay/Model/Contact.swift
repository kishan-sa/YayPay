//
//  Contacts.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 08/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import Foundation

class Contact {
    var name = ""
    var phonenumber = ""
    func format(){
        self.phonenumber = self.phonenumber.replacingOccurrences(of: " ", with: "")
        self.phonenumber = self.phonenumber.replacingOccurrences(of: "(", with: "")
        self.phonenumber = self.phonenumber.replacingOccurrences(of: ")", with: "")
//        self.phonenumber = self.phonenumber.replacingOccurrences(of: "+", with: "")
    }
}

