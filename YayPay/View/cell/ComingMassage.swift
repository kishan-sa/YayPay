//
//  ComingMassage.swift
//  YayPay
//
//  Created by  Kishan Vekariya on 19/07/19.
//  Copyright © 2019  Kishan Vekariya. All rights reserved.
//

import UIKit

class ComingMassage: UITableViewCell {

    @IBOutlet weak var massagelael: UILabel!
    @IBOutlet weak var uiview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        uiview.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
