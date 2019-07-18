//
//  ProfileVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 16/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController ,UIScrollViewDelegate{

    @IBOutlet weak var accountinfoview: UIView!
    @IBOutlet weak var privacyview: UIView!
    @IBOutlet weak var adbutton: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var emaillabel: UILabel!
    var name = ""
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        namelabel.text = name
        emaillabel.text = email
        accountinfoview.layer.cornerRadius = 10
        privacyview.layer.cornerRadius = 10
        adbutton.layer.borderColor = UIColor(red: 128/255, green: 44/255, blue: 227/255, alpha: 1).cgColor
        adbutton.layer.borderWidth = 1
        adbutton.layer.cornerRadius = 37/2
        adbutton.clipsToBounds = true
        scrollview.delegate = self
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollview.contentSize = CGSize(width:self.view.frame.width, height: self.view.frame.height + 160)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //disable bounce only at the top of the screen
        scrollview.bounces = scrollview.contentOffset.y > 100
    }
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
