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
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var emaillabel: UILabel!
    @IBOutlet var backimageview: [UIImageView]!
    @IBOutlet var nextimage: [UIImageView]!
    @IBOutlet var label: [UILabel]!
    
    private let itemsPerRow: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(top: 10.0,left: 20.0, bottom: 10.0,right: 20.0)
    var array = ["1","2"]
    var db : Firestore!
    var cards : [Card] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        readcards()
        readnameandemail()
        self.navigationController?.navigationBar.isHidden = true
        
        offersview.layer.cornerRadius = self.view.frame.height * 0.0805 / 2
        sendmoneyview.layer.cornerRadius = self.view.frame.height * 0.0805 / 2
        recievemoneyview.layer.cornerRadius = self.view.frame.height * 0.0805 / 2
        managemoneyview.layer.cornerRadius = self.view.frame.height * 0.0805 / 2
        collectionview.delegate = self
        collectionview.dataSource = self
    }

    @IBAction func sendButton(_ sender: Any) {
        sendmoneyview.removegradient()
        nextimage[0].tintColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
        label[0].textColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
        backimageview[0].image = UIImage()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "sendmoney") as! SendMoneyVC
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func recieveButton(_ sender: Any) {
        recievemoneyview.removegradient()
        nextimage[1].tintColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
        label[3].textColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
        backimageview[3].image = UIImage()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "reicevemoney") as! ReiceveMoneyVC
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func manageButton(_ sender: Any) {
        managemoneyview.removegradient()
        nextimage[2].tintColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
        label[2 ].textColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
        backimageview[1].image = UIImage()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "managemoney") as! ManageMoneyVC
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    @IBAction func offerButton(_ sender: Any) {
        offersview.removegradient()
        nextimage[3].tintColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
        label[1].textColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
        backimageview[2].image = UIImage()
//        do{
//            try Auth.auth().signOut()
//        }catch{
//            print(error)
//        }
    }
    
    @IBAction func profileButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "profile") as! ProfileVC
        nextViewController.name = namelabel.text!
        nextViewController.email = emaillabel.text!
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func sendinside(_ sender : UIButton){
        switch sender.tag {
        case 1:
            sendmoneyview.applyGradient()
            label[0].textColor = UIColor.white
            let origImage = UIImage(named: ">")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            nextimage[0].image = tintedImage
            nextimage[0].tintColor = .white
            backimageview[0].image = UIImage(named: "touch")
        case 2:
            recievemoneyview.applyGradient()
            label[3].textColor = UIColor.white
            let origImage = UIImage(named: ">")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            nextimage[1].image = tintedImage
            nextimage[1].tintColor = .white
            backimageview[3].image = UIImage(named: "touch")
        case 3:
            managemoneyview.applyGradient()
            label[2].textColor = UIColor.white
            let origImage = UIImage(named: ">")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            nextimage[2].image = tintedImage
            nextimage[2].tintColor = .white
            backimageview[1].image = UIImage(named: "touch")
        case 4:
            offersview.applyGradient()
            label[1].textColor = UIColor.white
            let origImage = UIImage(named: ">")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            nextimage[3].image = tintedImage
            nextimage[3].tintColor = .white
            backimageview[2].image = UIImage(named: "touch")
        default: break
            
        }
    }
    @IBAction func sendoutside(_ sender : UIButton){
        
        switch sender.tag {
        case 1:
            sendmoneyview.removegradient()
            nextimage[0].tintColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
            label[0].textColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
            backimageview[0].image = UIImage()
        case 2:
            recievemoneyview.removegradient()
            nextimage[1].tintColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
            label[3].textColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
            backimageview[3].image = UIImage()
        case 3:
            managemoneyview.removegradient()
            nextimage[2].tintColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
            label[2 ].textColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
            backimageview[1].image = UIImage()
        case 4:
            offersview.removegradient()
            nextimage[3].tintColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
            label[1].textColor = UIColor(red: 113/255, green: 44/255, blue: 226/255, alpha: 1)
            backimageview[2].image = UIImage()
        default: break
            
        }
    }
    
}
extension UIView {
    func applyGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 142/255, green: 45/255, blue: 226/255, alpha: 1).cgColor,UIColor(red: 74/255, green: 0/255, blue: 224/255, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = self.bounds
        gradient.cornerRadius = self.frame.height / 2
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    func removegradient(){
        self.layer.sublayers![0] = CAGradientLayer()
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
        return CGSize(width: 185, height: self.collectionview.frame.height - 5)
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
                    let newcard = Card(accountnumber: document.data()["accountnumber"] as! String, balance: document.data()["balance"] as! String)
                    newcard.mask()
                    self.cards.append(newcard)
                }
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                }
            }
        }
    }
    func readnameandemail(){
        let userid = Auth.auth().currentUser?.uid
        db = Firestore.firestore()
        db.collection("users").document("\(userid!)").getDocument { (querySnapshot, err) in
            if let err = err {
                print("error reading cards : \(err.localizedDescription)")
            }else{
                if let name = querySnapshot?.data()?["name"]{
                    self.namelabel.text = name as? String
                }
                if let email = querySnapshot?.data()?["email"]{
                    self.emaillabel.text = email as? String
                }
            }
        }
    }
    
}
