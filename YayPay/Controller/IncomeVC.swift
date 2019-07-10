//
//  IncomeVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 09/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class IncomeVC: UIViewController {

    @IBOutlet weak var incomeTF: UITextField!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var addincomeview: UIView!
    
    var db : Firestore!
    
    var dates = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentdate : Int?
    var currentyear : Int?
    var currentdateindex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incomeTF.borderStyle = UITextField.BorderStyle.none
        let datecomp2 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        currentdateindex = datecomp2.month! - 1
        currentyear = datecomp2.year!
        currentdate = datecomp2.month! - 1
        datelabel.text = "\(dates[currentdate!]) \(currentyear!)"
        
    }
    
    @IBAction func sidebuttoPressed(_ sender: UIButton) {
        if sender.tag == 2{
            if currentdateindex == 11{
                currentyear = currentyear! + 1
            }
            currentdateindex = (currentdateindex! + 1) % 12
            datelabel.text = "\(dates[currentdateindex!]) \(currentyear!)"
            
        }else if sender.tag == 1{
            if currentdateindex == 0{
                currentyear = currentyear! - 1
            }
            currentdateindex = (currentdateindex! - 1) % 12
            if currentdateindex == -1{
                currentdateindex = 11
            }
            datelabel.text = "\(dates[currentdateindex!]) \(currentyear!)"
        }
    }
    
    @IBAction func addincomepressed(_ sender: Any) {
        addincome()
    }
}

extension IncomeVC{
    func addincome(){
        
        let userid = Auth.auth().currentUser?.uid
        
        db = Firestore.firestore()
        db.collection("users").document("\(userid!)").collection("income").document("\(datelabel.text!)").setData(["income" : "\(incomeTF.text!)"], completion: { (err) in
            if let error = err{
                print("error : \(error.localizedDescription)")
            }else{
                print("income added successfullys")
                self.incomeTF.text = ""
            }
        })
    }
}

