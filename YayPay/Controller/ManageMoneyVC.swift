//
//  ManageMoneyVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 08/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import UICircularProgressRing
import FirebaseAuth
import FirebaseFirestore

class ManageMoneyVC: UIViewController {

    @IBOutlet weak var inexpuiview: UIView!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var incomprogress: UICircularProgressRing!
    @IBOutlet weak var expenseprogress: UICircularProgressRing!
    @IBOutlet weak var incomelabel: UILabel!
    @IBOutlet weak var expenselabel: UILabel!
    @IBOutlet weak var addview: UIView!
    
    var db : Firestore!
    
    var expenses : [Expense] = []
    var dates = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentdate : Int?
    var currentyear : Int?
    var currentdateindex : Int?
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0,left: 20.0, bottom: 10.0,right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addview.layer.cornerRadius = 65 / 2
        inexpuiview.layer.cornerRadius = 60
        let datecomp2 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        currentdateindex = datecomp2.month! - 1
        currentyear = datecomp2.year!
        currentdate = datecomp2.month! - 1
        datelabel.text = "\(dates[currentdate!]) \(currentyear!)"
        collectionview.delegate = self
        collectionview.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        readincome()
        readxepenses()
    }
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "addentry") as! AddEntryVC
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func sidebutttonPressed(_ sender: UIButton) {
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
        self.incomprogress.value = 0
        self.expenseprogress.value = 100
        readincome()
        //readtotalexpense()
        readxepenses()
    }
    
}
//MARK:- database methods
extension ManageMoneyVC {
    func readincome(){
        let userid = Auth.auth().currentUser?.uid
        db = Firestore.firestore()
        db.collection("users").document("\(userid!)").collection("income").document("\(datelabel.text!)").getDocument { (documentSnapshot, error) in
            if let err = error {
                print("error : \(err.localizedDescription)")
            }else{
                if let d = documentSnapshot?.data()?["income"]{
                    self.incomelabel.text = "\(d)"
                    self.incomprogress.startProgress(to: 100, duration: 2)
                    self.readtotalexpense()
                }
                
            }
        }
    }
    func readtotalexpense(){
        let userid = Auth.auth().currentUser?.uid
        db = Firestore.firestore()
        db.collection("users").document("\(userid!)").collection("expense").document("\(currentdateindex!) 2019").getDocument { (documentSnapshot, error) in
            if let err = error {
                print("error : \(err.localizedDescription)")
            }else{
                if let d = documentSnapshot?.data()?["total"]{
                    print(d as! String)
                    self.expenselabel.text = (d  as! String)
                    let income = Int(self.incomelabel.text!) ?? 0
                    let expense = Int(self.expenselabel.text!) ?? 1
                    self.incomprogress.startProgress(to: 100 - CGFloat(expense) / CGFloat(income) * 100, duration: 2)
                    self.expenseprogress.startProgress(to: CGFloat(expense) / CGFloat(income) * 100, duration: 2)
                }
                
            }
        }
    }
    func readxepenses(){
        expenses = []
        let userid = Auth.auth().currentUser?.uid
        db = Firestore.firestore()
        db.collection("users").document("\(userid!)").collection("expense").document("\(currentdateindex!) 2019").collection("expenses").getDocuments { (querySnapshot, error) in
            if let err = error {
                print("error : \(err.localizedDescription)")
                
            }else{
                for document in (querySnapshot!.documents){
                    print("documents of expences")
                    print(document.data())
                    
                    let data = document.data()
                    let newexp = Expense(category: data["category"] as! String, expense: data["expense"] as! String, reason: data["reason"] as! String)
                    
                    self.expenses.append(newexp)
                }
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                }
            }
        }
    
    }
}
//MARK:- collection view methods
extension ManageMoneyVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return expenses.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "expensecell", for: indexPath) as! ExpenseCell
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.backgroundColor = UIColor.white
        cell.categorylabel.text = expenses[indexPath.row].category
        print("\(String(describing: expenses[indexPath.row].category))")
        
        cell.imageview.image = UIImage(named: "\(String(describing: expenses[indexPath.row].category!))")
        cell.moneylabel.text = "$\(expenses[indexPath.row].expense!)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //categorylabel.text = category[indexPath.row]
        collectionView.deselectItem(at: indexPath, animated: false)
    }

}


extension ManageMoneyVC : UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: 220)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
