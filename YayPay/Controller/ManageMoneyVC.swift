//
//  ManageMoneyVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 08/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import UICircularProgressRing

class ManageMoneyVC: UIViewController {

    @IBOutlet weak var inexpuiview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
            inexpuiview.layer.cornerRadius = 60
        }
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "addentry") as! AddEntryVC
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

