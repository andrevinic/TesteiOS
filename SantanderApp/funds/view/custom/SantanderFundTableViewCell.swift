//
//  SantanderFundTableViewCell.swift
//  SantanderApp
//
//  Created by Andre Nogueira
//  Copyright © 2018 Andre Nogueira. All rights reserved.
//

import UIKit

class SantanderFundTableViewCell: UITableViewCell {

    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var downloadIcon: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
