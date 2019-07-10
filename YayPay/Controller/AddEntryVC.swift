//
//  AddEntryVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 09/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit

class AddEntryVC: UIViewController {

    @IBOutlet weak var incomeview: UIView!
    @IBOutlet weak var expenseview: UIView!
    @IBOutlet weak var transferview: UIView!
    @IBOutlet weak var addbuttonview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addbuttonview.layer.cornerRadius = 20
    }

    @IBAction func swithViews(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            incomeview.alpha = 1
            expenseview.alpha = 0
            transferview.alpha = 0
        }
        else if sender.selectedSegmentIndex == 1{
            incomeview.alpha = 0
            expenseview.alpha = 1
            transferview.alpha = 0
        }
        else if sender.selectedSegmentIndex == 2{
            incomeview.alpha = 0
            expenseview.alpha = 0
            transferview.alpha = 1
        }
        
    }
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
