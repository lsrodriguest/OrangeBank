//
//  TransHeaderCell.swift
//  OrangeBank
//
//  Created by Luis Rodrigues on 24/01/2019.
//  Copyright © 2018 Luis Rodrigues. All rights reserved.
//

import UIKit

class TransHeaderCell: UITableViewCell {
    
    @IBOutlet weak var _date:        UILabel!
    @IBOutlet weak var _description: UILabel!
    @IBOutlet weak var _amount:      UILabel!
    @IBOutlet weak var _fee:         UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
}
