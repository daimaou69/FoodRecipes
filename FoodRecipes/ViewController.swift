//
//  ViewController.swift
//  FoodRecipes
//
//  Created by CNTT on 4/17/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func btnRegistry(_ sender: UIButton) {
        ref = Database.database().reference()
        
        let id = ref.childByAutoId()
        
        self.ref.child("User").child(id.key!).setValue([
            "userID":id.key!,
            "userName": txtUserName.text!,
            "password": txtPassword.text!])
    }
}

