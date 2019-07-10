//
//  ExpenseVC.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 09/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit

class ExpenseVC: UIViewController {
    
    

    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var categorylabel: UILabel!
    @IBOutlet weak var moneyTF: UITextField!
    @IBOutlet weak var reasonTF: UITextField!
    
    var category = ["Food","Fuel","Movie","Shopping"]
    var categoryimage = [UIImage(named: "food"),UIImage(named: "fuel"),UIImage(named: "movies"),UIImage(named: "shopping")]
    var images = [#imageLiteral(resourceName: "food"),#imageLiteral(resourceName: "fuel"),#imageLiteral(resourceName: "movies"),#imageLiteral(resourceName: "movies")]
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0,left: 20.0, bottom: 10.0,right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        moneyTF.borderStyle = UITextField.BorderStyle.none
        reasonTF.borderStyle = UITextField.BorderStyle.none

        collectionview.delegate = self
        collectionview.dataSource = self
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


