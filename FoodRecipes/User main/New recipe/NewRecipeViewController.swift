//
//  NewRecipeViewController.swift
//  FoodRecipes
//
//  Created by CNTT on 5/5/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit

class NewRecipeViewController: UIViewController {

    var userID:String!
    
    @IBOutlet weak var btnTest: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnTest.setTitle(userID, for: .normal)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
