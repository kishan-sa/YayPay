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
    @IBOutlet weak var income: UIButton!
    @IBOutlet weak var expense: UIButton!
    @IBOutlet weak var transfer: UIButton!
    
    var color = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        income.layer.cornerRadius = 10
        income.clipsToBounds = true
        expense.layer.cornerRadius = 10
        expense.clipsToBounds = true
        transfer.layer.cornerRadius = 10
        transfer.clipsToBounds = true
        color = expense.backgroundColor!
    }

    @IBAction func buttonpressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            expense.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            transfer.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            expense.setTitleColor(UIColor.gray, for: .normal)
            transfer.setTitleColor(UIColor.gray, for: .normal)
            income.setTitleColor(UIColor.white, for: .normal)
            income.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            income.backgroundColor = color
            expense.backgroundColor = UIColor.clear
            transfer.backgroundColor = UIColor.clear
            incomeview.alpha = 1
            expenseview.alpha = 0
            transferview.alpha = 0
            
        case 2:
            income.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            transfer.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            income.setTitleColor(UIColor.gray, for: .normal)
            transfer.setTitleColor(UIColor.gray, for: .normal)
            expense.setTitleColor(UIColor.white, for: .normal)
            expense.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            expense.backgroundColor = color
            income.backgroundColor = UIColor.clear
            transfer.backgroundColor = UIColor.clear
            incomeview.alpha = 0
            expenseview.alpha = 1
            transferview.alpha = 0
            
        case 3:
            income.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            expense.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            expense.setTitleColor(UIColor.gray, for: .normal)
            income.setTitleColor(UIColor.gray, for: .normal)
            transfer.setTitleColor(UIColor.white, for: .normal)
            transfer.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            transfer.backgroundColor = color
            income.backgroundColor = UIColor.clear
            expense.backgroundColor = UIColor.clear
            incomeview.alpha = 0
            expenseview.alpha = 0
            transferview.alpha = 1
            
        default: break
        }
    }
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
