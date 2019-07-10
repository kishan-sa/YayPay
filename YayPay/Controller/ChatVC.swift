//
//  ChatVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 08/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    var unamefromsendmoney = ""
    var phonenofromsendmoney = ""
    
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var phonenumberlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        namelabel.text = unamefromsendmoney
        phonenumberlabel.text = phonenofromsendmoney
        
    }
    

    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
