//
//  ExpenseVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 09/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ExpenseVC: UIViewController {
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var categorylabel: UILabel!
    @IBOutlet weak var moneyTF: UITextField!
    @IBOutlet weak var reasonTF: UITextField!
    @IBOutlet weak var addexpenseview: UIView!
    
    var db : Firestore!
    
    var totalexp = 0
    var datestring = ""
    var category = ["Food","Fuel","Movie","Shopping"]
    var categoryimage = [UIImage(named: "food"),UIImage(named: "fuel"),UIImage(named: "movies"),UIImage(named: "shopping")]
    var images = [#imageLiteral(resourceName: "Food"),#imageLiteral(resourceName: "Fuel"),#imageLiteral(resourceName: "Movie"),#imageLiteral(resourceName: "Shopping")]
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0,left: 20.0, bottom: 10.0,right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        moneyTF.borderStyle = UITextField.BorderStyle.none
        reasonTF.borderStyle = UITextField.BorderStyle.none

        collectionview.delegate = self
        collectionview.dataSource = self
        addexpenseview.layer.cornerRadius = 30
        
        let datecomp2 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
//        currentdateindex = datecomp2.month! - 1
//        currentyear = datecomp2.year!
//        currentdate = datecomp2.month! - 1
        datestring = "\(datecomp2.month! - 1) \(datecomp2.year!)"
        //readtotalexp()
    }
    
    @IBAction func addexp(_ sender: Any) {
        if moneyTF.text == ""{
            let alert = UIAlertController(title: "Money", message: "Enter Money", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if reasonTF.text == ""{
            let alert = UIAlertController(title: "Reason", message: "Enter Reason", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (categorylabel.text!) == "Which category does this belong to?"{
            let alert = UIAlertController(title: "Category", message: "Select Any CateGory", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            addexpense()
            readtotalexp()
        }
        
    }
}

extension ExpenseVC {
    
    func addexpense(){
        let userid = Auth.auth().currentUser?.uid
        db = Firestore.firestore()
        db.collection("users").document("\(userid!)").collection("expense").document("\(datestring)").collection("expenses").addDocument(data: ["expense":"\(moneyTF.text!)","reason":"\(reasonTF.text!)","category":"\(categorylabel.text!)"]) { (err) in
            if let error = err {
                print("error : \(error.localizedDescription)")
            }else{
                print("expense added")
            }
        }
    }
    func addtotalexp() {
        
        let userid = Auth.auth().currentUser?.uid
        
        totalexp = totalexp + Int(moneyTF.text!)!
        db.collection("users").document("\(userid!)").collection("expense").document("\(datestring)").setData(["total":"\(totalexp)"]) { (error) in
            if let error = error{
                print("errrror:\(error)")
            }else{
                print("total set")
            }
        }
    }
    func readtotalexp(){
        db = Firestore.firestore()
        let userid = Auth.auth().currentUser?.uid
        
        db.collection("users").document("\(userid!)").collection("expense").document("\(datestring)").getDocument { (documentSnapshot, error) in
            if let err = error {
                print("error : \(err)")
            }else{
                print(documentSnapshot?.data()!["total"] as! String)
                self.totalexp = Int(documentSnapshot?.data()!["total"] as! String)!
                self.addtotalexp()
            }
        }
    }
}

extension ExpenseVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorycell", for: indexPath) as! CategoryCell
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.backgroundColor = UIColor.white
        cell.categoryname.text = category[indexPath.row]
        cell.categoryimage.image = images[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categorylabel.text = category[indexPath.row]
    }
}


extension ExpenseVC : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


