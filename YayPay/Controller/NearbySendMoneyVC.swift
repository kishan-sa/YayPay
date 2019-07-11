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

class NearbySendMoneyVC: UIViewController ,CLLocationManagerDelegate{
    
    @IBOutlet weak var tableviewcontainerview: UIView!
    @IBOutlet weak var tableview: UITableView!
    let locationManager = CLLocationManager()
    var latitude : Double = 0
    var longitude : Double = 0
    var db : Firestore!
    var arraylat : [String] = []
    var arraylong : [String] = []
    var arrayuser : [String] = []
    var nearby : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        tableview.delegate = self
        tableview.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        readreceivers()
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
        if nearby.count != 0 {
            tableview.reloadData()
            tableviewcontainerview.alpha = 1
        }
    }
}
extension NearbySendMoneyVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearby.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "send", for: indexPath) as! ContactCell
        cell.namelabel.text = nearby[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "chatvc") as! ChatVC
//        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

extension NearbySendMoneyVC {
    func addlocation(){
        let userid = Auth.auth().currentUser?.uid
        db.collection("transfer").addDocument(data: ["lat":"\(latitude)","long":"\(longitude)","userid":"\(userid!)"], completion: { (error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                print("added")
            }
        })
    }
    func readreceivers(){
        db.collection("reciever").getDocuments { (querySnapshot, error) in
            if let err = error{
                print(err.localizedDescription)
            }else{
                for document in querySnapshot!.documents{
                    print("\(document.data()["lat"] as! String)")
                    print("\(document.data()["long"] as! String)")
                    print("\(document.data()["userid"] as! String)")
                    self.arraylat.append("\(document.data()["lat"] as! String)")
                    self.arraylong.append("\(document.data()["long"] as! String)")
                    self.arrayuser.append("\(document.data()["userid"] as! String)")
                }
                self.calculate()
            }
        }
    }
}
