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
    
    var phonenumber = ""
    var ref : DatabaseReference!
    var recieverid = ""
    let random = UUID.init().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        sendview.layer.cornerRadius = 25
        reasonView.layer.cornerRadius = 25
        reasonTF.borderStyle = UITextField.BorderStyle.none
        moneyTF.borderStyle = UITextField.BorderStyle.none
        paytolabel.text = "Paying Money to \(phonenumber)"
        reduserid()
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        print(reasonTF.text!)
        print(moneyTF.text!)
        addpayment()
        //addpaymentforreciever()
    }
}

extension PayVC {
    func addpayment(){
        let userid = Auth.auth().currentUser?.uid
        
        ref.child("payments").child("\(userid!)").child("\(recieverid)").child(random).child("amount").setValue("\(moneyTF.text!)", andPriority: nil, withCompletionBlock: { (error, databaseReference) in
            if let err = error{
                print("errrrrrrrrrr--------\(err.localizedDescription)")
            }else{
                print("payment success")
            }
        })
        ref.child("payments").child("\(userid!)").child("\(recieverid)").child(random).child("reason").setValue("\(reasonTF.text!)", andPriority: nil, withCompletionBlock: { (error, databaseReference) in
            if let err = error{
                print("errrrrrrrrrr--------\(err.localizedDescription)")
            }else{
                print("payment success")
            }
        })
        ref.child("payments").child("\(userid!)").child("\(recieverid)").child(random).child("iam").setValue("sender", andPriority: nil, withCompletionBlock: { (error, databaseReference) in
            if let err = error{
                print("errrrrrrrrrr--------\(err.localizedDescription)")
            }else{
                print("payment success")
            }
        })
    }
    func reduserid(){
        print(phonenumber)
        
        ref.child("users").child("\(phonenumber)").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary{
                self.recieverid = (value["uid"] as? String)!
            }
        } 
    }
    func addpaymentforreciever(){
        let userid = Auth.auth().currentUser?.uid
        ref.child("payments").child(recieverid).child(userid!).child(random).child("amount").setValue(moneyTF.text!, andPriority: nil) { (error, databaseReference) in
            if let err = error{
                print("errrrrrrrrrr--------\(err.localizedDescription)")
            }else{
                print("payment success")
            }
        }
        ref.child("payments").child(recieverid).child(userid!).child(random).child("reason").setValue(reasonTF.text!, andPriority: nil) { (error, databaseReference) in
            if let err = error{
                print("errrrrrrrrrr--------\(err.localizedDescription)")
            }else{
                print("payment successš")
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
        }
    }
}
