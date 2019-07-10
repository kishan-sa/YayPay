//
//  SignUpVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 09/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import FlagPhoneNumber
import FirebaseAuth

class SignUpVC: UIViewController {

    @IBOutlet weak var PhonenumberTF: FPNTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if Auth.auth().currentUser != nil{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "viewcontroller") as! ViewController
            navigationController?.pushViewController(nextViewController, animated: false)
        }
    }
  
    @IBAction func submitPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "otpvc") as! OTPVC
        if let phoneno = PhonenumberTF.getRawPhoneNumber(){
            
            nextViewController.phonenumber = phoneno
        }
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
