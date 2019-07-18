//
//  ChatVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 08/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChatVC: UIViewController {

    var unamefromsendmoney = ""
    var phonenofromsendmoney = ""
    var ref : DatabaseReference! = nil
    var recieverid = ""
    var payments : [Payment] = []
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var phonenumberlabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var payview: UIView!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var sendimageview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendimageview.layer.cornerRadius = 20
        sendimageview.clipsToBounds = true
        textfield.borderStyle = .none
        textfield.layer.cornerRadius = 30
        textfield.clipsToBounds = true
        textfield.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        ref = Database.database().reference()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "InComingCell", bundle: nil), forCellReuseIdentifier: "out")
        tableview.register(UINib(nibName: "OutGoingCell", bundle: nil), forCellReuseIdentifier: "in")
        //it reads payments from userid of currentuser
        //readuserid()
        payview.layer.cornerRadius = 30
        namelabel.text = unamefromsendmoney
        phonenumberlabel.text = phonenofromsendmoney
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //it reads payments also
        readuserid()
    }

    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "pin") as! PinVC
        nextViewController.passtopayvcphone = phonenofromsendmoney
        nextViewController.passtopayvcname = unamefromsendmoney
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
//MARK:- database methods
extension ChatVC{
    func readpayments() {
        payments = []
        let userid = Auth.auth().currentUser?.uid
        let q = (ref.child("payments").child(userid!).child(recieverid)).queryOrdered(byChild: "time")
            q.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChildren(){
                
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                for (_, theValue) in postDict {
                    if let val = theValue as? Dictionary<String,Any> {
                        self.payments.append(Payment(amount: Int("\(val["amount"]!)")! , reason: (val["reason"]! as? String)!, iam:(val["iam"]! as? String)!, time: Int("\(val["time"]!)")!))
                    }
                }
                let pay = self.payments.sorted(by: { $0.time < $1.time })
                self.payments = pay
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }else{
                print("no childern")
            }  
        }
    }
    func readuserid(){
        
        ref.child("users").child("\(phonenofromsendmoney)").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary{
                self.recieverid = (value["uid"] as? String)!
                self.readpayments()
            }
        }
    }
}

//MARK:- table view's methods
extension ChatVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if payments[indexPath.row].iam == "sender"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "out", for: indexPath) as! InComingCell
            cell.moneylabel.text = "$\(payments[indexPath.row].amount)"
            cell.reasonlabel.text = payments[indexPath.row].reason
            cell.containerview.layer.cornerRadius = 10
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "in", for: indexPath) as! OutGoingCell
            cell.moneylabel.text = "$\(payments[indexPath.row].amount)"
            cell.reasonlabel.text = payments[indexPath.row].reason
            cell.containerview.layer.cornerRadius = 10
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}

