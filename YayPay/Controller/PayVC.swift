//
//  PayVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 12/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import Firebase

class PayVC: UIViewController {

    @IBOutlet weak var moneyTF: UITextField!
    @IBOutlet weak var reasonTF: UITextField!
    @IBOutlet weak var paytolabel: UILabel!
    @IBOutlet weak var reasonView: UIView!
    @IBOutlet weak var sendview: UIView!
    @IBOutlet weak var sendbutton: UIButton!
    
    var phonenumber = ""
    var name = ""
    var ref : DatabaseReference!
    var recieverid = ""
    let random = UUID.init().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        sendview.layer.cornerRadius = 25
        reasonView.layer.cornerRadius = 25
        sendbutton.layer.cornerRadius = 25
        sendbutton.clipsToBounds = true
        reasonTF.borderStyle = UITextField.BorderStyle.none
        moneyTF.borderStyle = UITextField.BorderStyle.none
        moneyTF.attributedPlaceholder = NSAttributedString(string: "How Much?",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        reasonTF.attributedPlaceholder = NSAttributedString(string: "What's this for?",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        reasonTF.delegate = self
        moneyTF.delegate = self
        moneyTF.becomeFirstResponder()
        paytolabel.text = "Paying Money to \(name)"
        reduserid()
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        addpayment2()
    }
    @IBAction func backpressed(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: false)
    }
}

extension PayVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PayVC {
    
    func addpayment2(){
        
        let userid = Auth.auth().currentUser?.uid
        let ref1 = ref.child("chat").child("\(userid!)").child("\(recieverid)").child("\(formatdate())")
        ref1.child("amount").setValue("\(moneyTF.text!)", andPriority: nil, withCompletionBlock: { (error, databaseReference) in
            if let err = error{
                print("errrrrrrrrrr--------\(err.localizedDescription)")
            }else{
                //print("payment success")
            }
        })
        ref1.child("reason").setValue("\(reasonTF.text!)", andPriority: nil, withCompletionBlock: { (error, databaseReference) in
            if let err = error{
                print("errrrrrrrrrr--------\(err.localizedDescription)")
            }else{
                //print("payment success")
            }
        })
        ref1.child("iam").setValue("sender", andPriority: nil, withCompletionBlock: { (error, databaseReference) in
            if let err = error{
                print("errrrrrrrrrr--------\(err.localizedDescription)")
            }else{
            }
        })
        ref1.child("type").setValue("p", andPriority: nil, withCompletionBlock: { (error, databaseReference) in
            if let err = error{
                print("errrrrrrrrrr--------\(err.localizedDescription)")
            }else{
                self.addpaymentforreciever2()
            }
        })
    }
    func formatdate() -> Int{
        let date = Date().description
        let string = date.replacingOccurrences(of: " ", with: "")
        let string1 = string.replacingOccurrences(of: "-", with: "")
        let string2 = string1.replacingOccurrences(of: ":", with: "")
        let string3 = string2.replacingOccurrences(of: "+", with: "")
        let integerdate = Int(string3) ?? 0
        
        return integerdate
    }
    func reduserid(){
        ref.child("users").child("\(phonenumber)").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary{
                self.recieverid = (value["uid"] as? String)!
            }
        } 
    }
    func addpaymentforreciever2(){
        let userid = Auth.auth().currentUser?.uid
        let ref1 = ref.child("chat").child(recieverid).child(userid!).child("\(formatdate())")
        ref1.child("amount").setValue(moneyTF.text!, andPriority: nil) { (error, databaseReference) in
            if let err = error{
                print("errrrrrrrrrr--------\(err.localizedDescription)")
            }else{
            }
        }
        ref1.child("reason").setValue(reasonTF.text!, andPriority: nil) { (error, databaseReference) in
            if let err = error{
                print("errrrrrrrrrr--------\(err.localizedDescription)")
            }else{
                
            }
        }
        ref1.child("type").setValue("p", andPriority: nil) { (error, databaseReference) in
            if let err = error{
                print("errrrrrrrrrr--------\(err.localizedDescription)")
            }else{
                
            }
        }
        ref1.child("iam").setValue("r", andPriority: nil) { (error, databaseReference) in
            if let err = error{
                print("errrrrrrrrrr--------\(err.localizedDescription)")
            }else{  
                print("payment success")
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
        }
    }
}
