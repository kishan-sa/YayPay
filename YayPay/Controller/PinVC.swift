//
//  Pin.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 12/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PinVC: UIViewController {

    @IBOutlet weak var dot1: UIView!
    @IBOutlet weak var dot3: UIView!
    @IBOutlet weak var dot4: UIView!
    @IBOutlet weak var dot2: UIView!
    @IBOutlet weak var pinTF: UITextField!
    
    var db : Firestore!
    var pin = 0
    var passtopayvc = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        dot1.layer.cornerRadius = 15
        dot2.layer.cornerRadius = 15
        dot3.layer.cornerRadius = 15
        dot4.layer.cornerRadius = 15
        db = Firestore.firestore()
        readpin()
    }
    
    @IBAction func next(_ sender: UIButton) {
        let pinint = Int(pinTF.text!)
        if pin == pinint{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "pay") as! PayVC
            nextViewController.phonenumber = passtopayvc
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}

extension PinVC {
    func readpin(){
        let userid = Auth.auth().currentUser?.uid
        db.collection("users").document("\(userid!)").getDocument { (documentSnapshot, error) in
            if let err = error{
                print(err.localizedDescription)
            }else{
                self.pin = documentSnapshot?.data()!["pin"] as! Int
            }
        }
    }
}

//func  read() {
//
//    SVProgressHUD.show()
//    db = Firestore.firestore()
//    postss = []
//
//    db.collection("postss").getDocuments() { (querySnapshot, err) in
//        if let err = err {
//            print("Error getting documents: \(err)")
//        } else {
//            for document in querySnapshot!.documents {
//                
//                let newpost = Post()
//                print("\(document.documentID) => \(document.data())")
//                self.posts.append(document.documentID)
//                newpost.post = "\(document.data()["postdata"] as! String)"
//                newpost.imagename = "\(document.documentID)"
//
//                // Create a reference to the file you want to download
//                let storageRef = Storage.storage().reference(withPath: "images/\(document.documentID).jpg")
//                
//                // Download in memory with a maximum allowed size of 4MB (4 * 1024 * 1024 bytes)
//                storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
//                    if let error = error {
//                        print("error downloading image:\(error)")
//
//                    } else {
//                        // Data for "images/island.jpg" is returned
//                        newpost.image = UIImage(data: data!)
//                        self.postss.append(newpost)
//                        DispatchQueue.main.async {
//                            self.tableview.reloadData()
//                        }
//                    }
//                }
//            }
//        }
//        SVProgressHUD.dismiss()
//    }
//}