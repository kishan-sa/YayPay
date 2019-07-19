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
    var userid = Auth.auth().currentUser?.uid
    var payments : [Payment] = []
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var phonenumberlabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var payview: UIView!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var sendimageview: UIImageView!
    @IBOutlet weak var sendview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendview.layer.cornerRadius = 30
        tableview.allowsSelection = false
        sendimageview.layer.cornerRadius = 20
        sendimageview.clipsToBounds = true
        textfield.borderStyle = .none
        ref = Database.database().reference()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "InComingCell", bundle: nil), forCellReuseIdentifier: "out")
        tableview.register(UINib(nibName: "OutGoingCell", bundle: nil), forCellReuseIdentifier: "in")
        tableview.register(UINib(nibName: "ChatMassage", bundle: nil), forCellReuseIdentifier: "chat")
        tableview.register(UINib(nibName: "ComingMassage", bundle: nil), forCellReuseIdentifier: "chat1")
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
    
    @IBAction func sendmassagePressed(_ sender: Any) {
        if textfield.text != ""{
            addmassage(massage: textfield.text!)
        }
    }
}
//MARK:- database methods
extension ChatVC{
    func readpayments2() {
        self.payments = []
        let userid = Auth.auth().currentUser?.uid
            (self.ref.child("chat").child(userid!).child(self.recieverid)).observe(.value) { (dataSnapshot) in
            
            if dataSnapshot.hasChildren(){
                let postDict = dataSnapshot.value as? [String : AnyObject] ?? [:]
                
                for (theKey, theValue) in postDict {
                    if let val = theValue as? Dictionary<String,Any> {
                        if let type = val["type"] as? String{
                            if type == "c"{
                                if let massage = val["massage"] as? String{
                                    let newmassage = Payment(massage: massage)
                                    newmassage.type = type
                                    print(theKey)
                                    newmassage.time = Int(theKey)!
                                    if let iam = val["iam"] as? String{
                                        newmassage.iam = iam
                                    }
                                    self.payments.append(newmassage)
                                    let pay = self.payments.sorted(by: { $0.time < $1.time })
                                    self.payments = pay
                                }
                            }
                            if type == "p"{
                                let newpayment = Payment()
                                if let amount = val["amount"]{
                                    newpayment.amount = Int("\(amount)") ?? 0
                                }
                                if let reason = val["reason"] as? String{
                                    newpayment.reason = reason
                                }
                                if let iam = val["iam"] as? String{
                                    newpayment.iam = iam
                                }
                                newpayment.time = Int(theKey)!
                                self.payments.append(newpayment)
                                let pay = self.payments.sorted(by: { $0.time < $1.time })
                                self.payments = pay
                            }
                        }
                    }
                }
                let pay = self.payments.sorted(by: { $0.time < $1.time })
                self.payments = pay
                self.payments = self.payments.removingDuplicates()
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
                self.readpayments2()
            }
        }
    }
    func addmassage(massage : String){
        let ref1 = ref.child("chat").child(userid!).child(recieverid).child("\(createtimeid())")
        ref1.child("massage").setValue("\(textfield.text!)") { (error, databaseReference) in
            if let err = error{
                print(err.localizedDescription)
            }else{
            }
        }
        ref1.child("type").setValue("c") { (error, databaseReference) in
            if let err = error{
                print(err.localizedDescription)
            }else{
                
            }
        }
        ref1.child("iam").setValue("sender") { (error, databaseReference) in
            if let err = error{
                print(err.localizedDescription)
            }else{
                self.addmassage2(massage: massage)
            }
        }
    }
    func addmassage2(massage : String){
        let ref1 = ref.child("chat").child(recieverid).child(userid!).child("\(createtimeid())")
        ref1.child("massage").setValue("\(textfield.text!)") { (error, databaseReference) in
            if let err = error{
                print(err.localizedDescription)
            }else{
            }
        }
        ref1.child("type").setValue("c") { (error, databaseReference) in
            if let err = error{
                print(err.localizedDescription)
            }else{
                
            }
        }
        ref1.child("iam").setValue("r") { (error, databaseReference) in
            if let err = error{
                print(err.localizedDescription)
            }else{
                self.textfield.text = ""
                self.readpayments2()
            }
        }
    }
    func createtimeid() -> Int{
        let date = Date().description
        let string = date.replacingOccurrences(of: " ", with: "")
        let string1 = string.replacingOccurrences(of: "-", with: "")
        let string2 = string1.replacingOccurrences(of: ":", with: "")
        let string3 = string2.replacingOccurrences(of: "+", with: "")
        let integerdate = Int(string3) ?? 0
        
        return integerdate
    }
}

//MARK:- table view's methods
extension ChatVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if payments[indexPath.row].type == "c"{
            if payments[indexPath.row].iam == "sender"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "chat", for: indexPath) as! ChatMassage
                cell.massagelabel.text = payments[indexPath.row].massage
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "chat1", for: indexPath) as! ComingMassage
                cell.massagelael.text = payments[indexPath.row].massage
                return cell
            }
            
        }else{
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
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if payments[indexPath.row].type == "c"{
            let heightOfRow = self.calculateHeight(inString: payments[indexPath.row].massage)
            return (heightOfRow + 40)
        }else{
            return 120
        }
    }
    func calculateHeight(inString:String) -> CGFloat
    {
        let messageString = inString
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18.0)]
        
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 207, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

