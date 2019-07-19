//
//  SendMoneyVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 08/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import Contacts
import FirebaseAuth
import Firebase


class SendMoneyVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    var contacts = [CNContact]()
    let store = CNContactStore()
    var contactsmodel = [Contact]()
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        tableview.delegate = self
        tableview.dataSource = self
        searchbar.backgroundImage = UIImage()
        searchbar.setImage(UIImage(named: "search"), for: .search, state: .normal)
        searchbar.layer.backgroundColor = UIColor.clear.cgColor
        searchbar.backgroundColor = UIColor.clear
        let searchTextField: UITextField? = searchbar.value(forKey: "searchField") as? UITextField
        if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
            let attributeDict = [NSAttributedString.Key.foregroundColor: UIColor(red: 120/255, green: 119/255, blue: 134/255, alpha: 1)]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Search people or enter a number", attributes: attributeDict)
            searchTextField?.backgroundColor = UIColor.clear
        }
        ref = Database.database().reference()
        readphonenumbers()
        
        //fetch contacts
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName) , CNContactPhoneNumbersKey as CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        do {
            try self.store.enumerateContacts(with: request) {
                (contact, stop) in
                self.contacts.append(contact)
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        
        //loading model
        for i in contacts{
            let newcontact = Contact()
            newcontact.name = i.givenName
            newcontact.phonenumber = i.phoneNumbers[0].value.stringValue
            newcontact.format()
            checkphone(number: newcontact)
        }
    }

    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nearby(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "near") as! NearbySendMoneyVC
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}


//MARK:- table's methods
extension SendMoneyVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsmodel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactcell", for: indexPath) as! ContactCell
        
        cell.namelabel.text = contactsmodel[indexPath.row].name
        cell.contactnumberlabel.text = contactsmodel[indexPath.row].phonenumber
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "chatvc") as! ChatVC
        nextViewController.phonenofromsendmoney = contactsmodel[indexPath.row].phonenumber
        nextViewController.unamefromsendmoney = contactsmodel[indexPath.row].name
        navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//MARK:- database methods
extension SendMoneyVC{
    func readphonenumbers(){
        let userid = Auth.auth().currentUser?.uid
        ref.child("users").child(" \(userid!) ").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? NSDictionary{
                let username = value["phonenumber"] as! String
                print("realtime : \(username)")
            }
        
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func checkphone(number : Contact){
        
        ref.child("users").child(number.phonenumber).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if (snapshot.value as? NSDictionary) != nil{
                self.contactsmodel.append(number)
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
