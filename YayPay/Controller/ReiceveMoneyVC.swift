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

class ReiceveMoneyVC: UIViewController ,CLLocationManagerDelegate{
    
    @IBOutlet weak var containerview: UIView!
    @IBOutlet weak var tableview: UITableView!
    let locationManager = CLLocationManager()
    var db : Firestore!
    var arraylat : [String] = []
    var arraylong : [String] = []
    var arrayuser : [String] = []
    var latitude : String = ""
    var longitude : String = ""
    var nearby : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        readsenders()
        tableview.delegate = self
        tableview.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations.first
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        print("reciever :\t longitude = \(location!.coordinate.longitude),  latitude = \(location!.coordinate.latitude)")
            latitude = String(location!.coordinate.latitude)
            longitude = String(location!.coordinate.longitude)
            addlocation()
    }
    
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func calculate() {
        
        for item in 0..<arrayuser.count {
            let coordinate0 = CLLocation(latitude: Double(arraylat[item])!, longitude: Double(arraylong[item])!)
            let coordinate1 = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
            
            let distanceInMeters = coordinate0.distance(from: coordinate1)
            print("distance : \(distanceInMeters)")
            if distanceInMeters <= 50 {
                nearby.append(arrayuser[item])
                print(arrayuser[item])
            }
        }
        print(nearby)
        if nearby.count != 0{
            tableview.reloadData()
            containerview.alpha = 1
        }
        
    }
}

extension ReiceveMoneyVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearby.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyre", for: indexPath) as! ContactCell
        cell.namelabel.text = nearby[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}


extension ReiceveMoneyVC {
    func readsenders(){
        db.collection("transfer").getDocuments { (querySnapshot, error) in
            if let err = error{
                print(err.localizedDescription)
            }else{
                for documnet in querySnapshot!.documents{
                    print("\(documnet.data()["lat"] as! String)")
                    print("\(documnet.data()["long"] as! String)")
                    self.arraylat.append("\(documnet.data()["lat"] as! String)")
                    self.arraylong.append("\(documnet.data()["long"] as! String)")
                    self.arrayuser.append("\(documnet.data()["userid"] as! String)")
                }
                self.calculate()  
            }
        }
    }
    func addlocation(){
        let userid = Auth.auth().currentUser?.uid
        
        db.collection("reciever").addDocument(data: ["lat":"\(latitude)","long":"\(longitude)","userid":"\(userid!)"], completion: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                print("added")
            }
        })
    }
}

