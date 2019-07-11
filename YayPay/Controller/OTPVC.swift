//
//  OTPVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 09/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import FirebaseAuth

class OTPVC: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var otpTF: UITextField!
    var phonenumber = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = phonenumber
    }
    

    @IBAction func LoginPressed(_ sender: Any) {
        let otp = otpTF.text
        let sp = "\(phonenumber)"
        
        let sp2 = sp.replacingOccurrences(of: " ", with: "")
        
        Auth.auth().settings!.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber(sp2, uiDelegate:nil) {
            verificationID, error in
            if (error != nil) {
                // Handles error
                print("error varifying PhoneNumber: \(String(describing: error))")
                
                return
            }
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "",
                                                                     verificationCode: "\(otp!)")
            Auth.auth().signInAndRetrieveData(with: credential) { authData, error in
                if ((error) != nil) {
                    // Handles error
                    print("error in otp : \(String(describing: error?.localizedDescription))")
                    return
                }

                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "viewcontroller") as! ViewController
                self.navigationController?.pushViewController(nextViewController, animated: false)
                
            }
        }
        
    }
    
}
