//
//  ViewController.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 08/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import FirebaseFirestore
import  FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var offersview: UIView!
    @IBOutlet weak var managemoneyview: UIView!
    @IBOutlet weak var recievemoneyview: UIView!
    @IBOutlet weak var sendmoneyview: UIView!
    @IBOutlet weak var collectionview: UICollectionView!
    
    
    private let itemsPerRow: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(top: 10.0,left: 20.0, bottom: 10.0,right: 20.0)
    var array = ["1","2"]
    var db : Firestore!
    var cards : [Card] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        readcards()
        
        self.navigationController?.navigationBar.isHidden = true
        
        offersview.layer.cornerRadius = self.view.frame.height * 0.1 / 2
        sendmoneyview.layer.cornerRadius = self.view.frame.height * 0.1 / 2
        recievemoneyview.layer.cornerRadius = self.view.frame.height * 0.1 / 2
        managemoneyview.layer.cornerRadius = self.view.frame.height * 0.1 / 2
        collectionview.delegate = self
        collectionview.dataSource = self
    }

    @IBAction func sendButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "sendmoney") as! SendMoneyVC
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func recieveButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "managemoney") as! ManageMoneyVC
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func manageButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "managemoney") as! ManageMoneyVC
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func offerButton(_ sender: Any) {
    }
}

extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardcell", for: indexPath) as! CardCell
        cell.containerview.layer.cornerRadius = 15
        if !UIAccessibility.isReduceTransparencyEnabled {
            cell.blurview.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .prominent)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.layer.cornerRadius = 15
            blurEffectView.clipsToBounds = true
            
            cell.blurview.addSubview(blurEffectView)
        } else {
            cell.blurview.backgroundColor = .white
        }
        cell.accountnumberlabel.text = "\(String(describing: cards[indexPath.row].accountnumber!))"
        cell.balancelabel.text = "\(String(describing: cards[indexPath.row].balance!))"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: self.collectionview.frame.height - 5)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension ViewController{
    
    func readcards(){
        
        let userid = Auth.auth().currentUser?.uid
        db = Firestore.firestore()
        db.collection("users").document("\(userid!)").collection("cards").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("error reading cards : \(err.localizedDescription)")
            }else{
                for document in querySnapshot!.documents{
                    let newcard = Card(accountnumber: document.data()["accountnumber"] as! Int, balance: document.data()["balance"] as! Int)
                    print("detailes \(document.data()["accountnumber"] as! Int)   \(document.data()["balance"] as! Int)")
                    self.cards.append(newcard)
                }
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                }
            }
        }
    }
    
}


//func  read() {
//
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