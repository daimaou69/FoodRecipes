//
//  HomeTableViewCell.swift
//  FoodRecipes
//
//  Created by CNTT on 5/23/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodIMG: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var likes: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
