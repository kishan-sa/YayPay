//
//  SendMoneyVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 08/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import Contacts


class SendMoneyVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var contacts = [CNContact]()
    let store = CNContactStore()
    var contactsmodel = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        tableview.delegate = self
        tableview.dataSource = self
        
        //fetch contacts
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName) , CNContactPhoneNumbersKey as CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        do {
            try self.store.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                self.contacts.append(contact)
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        
        //loadind model
        for i in contacts{
            let newcontact = Contact()
            newcontact.name = i.givenName
            newcontact.phonenumber = i.phoneNumbers[0].value.stringValue
            contactsmodel.append(newcontact)
        }
        print(contactsmodel.last!.phonenumber)
        
        //reload table after model is loaded
        tableview.reloadData()
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


//MARK :- table's methods
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
