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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "InComingCell", bundle: nil), forCellReuseIdentifier: "out")
        tableview.register(UINib(nibName: "OutGoingCell", bundle: nil), forCellReuseIdentifier: "in")
        //it reads payments also
        //readuserid()
        
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
        nextViewController.passtopayvc = phonenofromsendmoney
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
extension ChatVC{
    func readpayments() {
        let userid = Auth.auth().currentUser?.uid
        
        ref.child("payments").child(userid!).child(recieverid).observeSingleEvent(of: .value) { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            for (_, theValue) in postDict {
                print(((theValue) as! Dictionary<String,String>)["amount"]!)
                print(((theValue) as! Dictionary<String,String>)["reason"]!)
                self.payments.append(Payment(amount: Int(((theValue) as! Dictionary<String,String>)["amount"]!)!, reason: ((theValue) as! Dictionary<String,String>)["reason"]!, iam: ((theValue) as! Dictionary<String,String>)["iam"]!))
            }
            print(self.payments.count)
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            
        }
        /*.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            for (_, theValue) in postDict {
                print(((theValue) as! Dictionary<String,String>)["amount"]!)
                print(((theValue) as! Dictionary<String,String>)["reason"]!)
                self.payments.append(Payment(amount: Int(((theValue) as! Dictionary<String,String>)["amount"]!)!, reason: ((theValue) as! Dictionary<String,String>)["reason"]!, iam: ((theValue) as! Dictionary<String,String>)["iam"]!))
            }
            print(self.payments.count)
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            
        })*/
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

extension ChatVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if payments[indexPath.row].iam == "sender"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "out", for: indexPath) as! InComingCell
            cell.moneylabel.text = "\(payments[indexPath.row].amount)"
            cell.reasonlabel.text = payments[indexPath.row].reason
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "in", for: indexPath) as! OutGoingCell
            cell.moneylabel.text = "\(payments[indexPath.row].amount)"
            cell.reasonlabel.text = payments[indexPath.row].reason
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }

}

