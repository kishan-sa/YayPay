//
//  ReiceveMoneyVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 08/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class ReiceveMoneyVC: UIViewController ,CLLocationManagerDelegate{
    
    @IBOutlet weak var containerview: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var animateview: UIView!
    @IBOutlet weak var searchinglabel: UILabel!
    
    let locationManager = CLLocationManager()
    var db : Firestore!
    var arraylat : [String] = []
    var arraylong : [String] = []
    var arrayuser : [String] = []
    var latitude : String = ""
    var longitude : String = ""
    var nearby : [String] = []
    var a1 : [String] = []
    var a2 : [String] = []
    var ref : DatabaseReference!
    let random = UUID.init().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        db = Firestore.firestore()
        readsenders()
        tableview.delegate = self
        tableview.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        animate()
        _ = Timer.scheduledTimer(timeInterval: 4.1, target: self, selector: #selector(self.animate), userInfo: nil, repeats: true)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        deletereciever()
    }
    
    @objc func animate(){
        //animate image
        UIView.animate(withDuration: 2.0, animations: {() -> Void in
            self.imageview?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.searchinglabel.text = "Searching for Nearby Devices.."
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 2.0, animations: {() -> Void in
                self.imageview?.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.searchinglabel.text = "Searching for Nearby Devices..."
            })
        })
    }

    @IBAction func backpressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations.first
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            latitude = String(location!.coordinate.latitude)
            longitude = String(location!.coordinate.longitude)
            addlocation()
    }
    

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func calculate() {
        
        for item in 0..<arrayuser.count {
            let coordinate0 = CLLocation(latitude: Double(arraylat[item])!, longitude: Double(arraylong[item])!)
            let coordinate1 = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
            
            let distanceInMeters = coordinate0.distance(from: coordinate1)
            if distanceInMeters <= 50 {
                nearby.append(arrayuser[item])
                print(arrayuser[item])
            }
        }
        if nearby.count != 0{
            nearby = nearby.removingDuplicates()
            readnameandnumber()
            if a1.count != 0 {
                a1 = a1.removingDuplicates()
                a2 = a2.removingDuplicates()
                tableview.reloadData()
                animateview.alpha = 0
                containerview.alpha = 1
            }
        }
    }
}

extension ReiceveMoneyVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return a1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyre", for: indexPath) as! ContactCell
        cell.namelabel.text = a1[indexPath.row]
        cell.contactnumberlabel.text = a2[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "chatvc") as! ChatVC
        nextViewController.phonenofromsendmoney = a2[indexPath.row]
        nextViewController.unamefromsendmoney = a1[indexPath.row]
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}


extension ReiceveMoneyVC {
    func readsenders(){
        arrayuser = []
        arraylong = []
        arraylat = []
        self.a1 = []
        self.a2 = []
        ref.child("senders").observe(.value) { (dataSnapshot) in
            self.arrayuser = []
            self.arraylong = []
            self.arraylat = []
            
            if dataSnapshot.hasChildren(){
                let postDict = dataSnapshot.value as? [String : AnyObject] ?? [:]
                for (_, theValue) in postDict{
                    if let val = theValue as? Dictionary<String,Any>{
                        if let lat = val["lat"] as? String{
                            if let long = val["long"] as? String{
                                if let user = val["userid"] as? String{
                                    self.arrayuser.append(user)
                                    self.arraylong.append(long)
                                    self.arraylat.append(lat)
                                }
                            }
                        }
                    }
                }
                
            }
            self.a1 = []
            self.a2 = []
            self.calculate()
        }
    }
    
    func addlocation(){
        
        let userid = Auth.auth().currentUser?.uid
        
        ref.child("reciever").child(random).child("lat").setValue("\(latitude)") { (error, databaseReference) in
            if let err = error{
                print("error : \(err.localizedDescription)")
            }else{
                print("added latitude")
            }
        }
        ref.child("reciever").child(random).child("long").setValue("\(longitude)") { (error, databaseReference) in
            if let err = error{
                print("error : \(err.localizedDescription)")
            }else{
                print("added longitude")
            }
        }
        ref.child("reciever").child(random).child("userid").setValue("\(userid!)") { (error, databaseReference) in
            if let err = error{
                print("error : \(err.localizedDescription)")
            }else{
                print("sender added")
            }
        }
    }
    func readnameandnumber(){
        a1 = []
        a2 = []
        for i in nearby{
            ref.child("users2").child(i).observeSingleEvent(of: .value) { (dataSnapshot) in
                let value = dataSnapshot.value as? NSDictionary
                let username = value?["name"] as? String ?? ""
                let phone = value?["phonenumber"] as? String ?? ""
                self.a1.append("\(username)")
                self.a2.append("\(phone)")
                DispatchQueue.main.async {
                    self.animateview.alpha = 0
                    self.containerview.alpha = 1
                    self.a1 = self.a1.removingDuplicates()
                    self.a2 = self.a2.removingDuplicates()
                    self.tableview.reloadData()
                }
            }
        }
    }
    func deletereciever(){
        ref.child("reciever").child(random).removeValue()
    }
}

