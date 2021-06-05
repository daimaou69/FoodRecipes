//
//  YourRepiceTableViewCell.swift
//  FoodRecipes
//
//  Created by CNTT on 6/1/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit

class YourRepiceTableViewCell: UITableViewCell {

    @IBOutlet weak var imageYourRepice: UIImageView!
    
    
    @IBOutlet weak var lblRepiceName: UILabel!
    
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
