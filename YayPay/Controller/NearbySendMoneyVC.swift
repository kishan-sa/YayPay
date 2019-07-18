//
//  NearbySendMoney.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 11/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class NearbySendMoneyVC: UIViewController ,CLLocationManagerDelegate{
    
    @IBOutlet weak var tableviewcontainerview: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var searchinglabel: UILabel!
    
    @IBOutlet weak var animateview: UIView!
    let locationManager = CLLocationManager()
    var latitude : Double = 0
    var longitude : Double = 0
    var db : Firestore!
    var arraylat : [String] = []
    var arraylong : [String] = []
    var arrayuser : [String] = []
    var nearby : [String] = []
    var ref : DatabaseReference!
    var a1 : [String] = []
    var a2 : [String] = []
    let random = UUID.init().uuidString
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        ref = Database.database().reference()
        tableview.delegate = self
        tableview.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        readreceivers()
        animate()
        _ = Timer.scheduledTimer(timeInterval: 4.1, target: self, selector: #selector(self.animate), userInfo: nil, repeats: true)
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        deletesender()
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
        print("sender : \t longitude = \(location!.coordinate.longitude),  latitude = \(location!.coordinate.latitude)")
        latitude = Double(location!.coordinate.latitude)
        longitude = Double(location!.coordinate.longitude)
        addlocation()
    }
    
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func calculate() {
        
        for item in 0..<arrayuser.count {
            let coordinate0 = CLLocation(latitude: Double(arraylat[item])!, longitude: Double(arraylong[item])!)
            let coordinate1 = CLLocation(latitude: latitude, longitude: longitude)
            
            let distanceInMeters = coordinate0.distance(from: coordinate1)
            print("distance : \(distanceInMeters)")
            if distanceInMeters <= 50 {
                nearby.append(arrayuser[item])
                print(arrayuser[item])
            }
        }
        print(nearby)
        if nearby.count != 0{
            readnameandnumber()
            
            if a1.count != 0 {
                tableview.reloadData()
                animateview.alpha = 0
                tableviewcontainerview.alpha = 1
            }
        }
    }
}
extension NearbySendMoneyVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return a1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "send", for: indexPath) as! ContactCell
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
        return 80
    }
}

extension NearbySendMoneyVC {
    func addlocation(){
        let userid = Auth.auth().currentUser?.uid
        
        ref.child("senders").child(random).child("lat").setValue("\(latitude)") { (error, databaseReference) in
            if let err = error{
                print("error : \(err.localizedDescription)")
            }else{
                print("added latitude")
            }
        }
        ref.child("senders").child(random).child("long").setValue("\(longitude)") { (error, databaseReference) in
            if let err = error{
                print("error : \(err.localizedDescription)")
            }else{
                print("added latitude")
            }
        }
        ref.child("senders").child(random).child("userid").setValue("\(userid!)") { (error, databaseReference) in
            if let err = error{
                print("error : \(err.localizedDescription)")
            }else{
                print("added latitude")
                print("added sender")
            }
        }
    }
    func readreceivers(){
        arrayuser = []
        arraylat = []
        arraylong = []
        
        ref.child("reciever").observe(.value) { (dataSnapshot) in
            if dataSnapshot.hasChildren(){
                let postDict = dataSnapshot.value as? [String : AnyObject] ?? [:]
                for (_, theValue) in postDict{
                    if let val = theValue as? Dictionary<String,Any>{
                        if let lat = val["lat"] as? String{
                            if let long = val["long"] as? String{
                                if let user = val["userid"] as? String{
                                    self.arraylat.append(lat)
                                    self.arraylong.append(long)
                                    self.arrayuser.append(user)
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
    }
    func readnameandnumber(){
        a1 = []
        a2 = []
        for i in nearby{
            print(i)    
            ref.child("users2").child(i).observeSingleEvent(of: .value) { (dataSnapshot) in
                let value = dataSnapshot.value as? NSDictionary
                let username = value?["name"] as? String ?? ""
                let phone = value?["phonenumber"] as? String ?? ""
                self.a1.append("\(username)")
                self.a2.append("\(phone)")
                print("count from send")
                print(self.a2.count)
                DispatchQueue.main.async {
                    self.animateview.alpha = 0
                    self.tableviewcontainerview.alpha = 1
                    self.tableview.reloadData()
                }
            }
        }
    }
    func deletesender(){
        ref.child("senders").child(random).removeValue()
    }
}
