//
//  ViewController.swift
//  FoodRecipes
//
//  Created by CNTT on 4/17/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import Firebase

class User{
    var userID:String
    var userName:String
    var fullName:String
    var image:String
    var dateOfBirth:String
    var email:String
    var phoneNumber:String
    var gender:String
    var password:String
    
    init(userID: String, userName:String, fullName:String, image:String, dateOfBirth:String, email:String, phoneNumber:String, gender:String, password:String) {
        self.userID = userID
        self.userName = userName
        self.fullName = fullName
        self.image = image
        self.dateOfBirth = dateOfBirth
        self.email = email
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.password = password
    }
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    var userData = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        
        databaseHandle = ref.child("User").observe(DataEventType.value, with: { (snapshot) in
            guard let values = snapshot.value as? [String: Any] else {
                return
            }
            
            self.userData = [User]()
            
            for (key, value) in values {
                guard let user = value as? [String: Any],
                    let userID = user["userID"] as? String,
                    let userName = user["userName"] as? String,
                    let fullName = user["fullName"] as? String,
                    let image = user["image"] as? String,
                    let dateOfBirth = user["dateOfBirth"] as? String,
                    let email = user["email"] as? String,
                    let phoneNumber = user["phoneNumber"] as? String,
                    let gender = user["gender"] as? String,
                    let password = user["password"] as? String else {
                        continue
                }
                
                self.userData.append(User(userID: userID, userName: userName, fullName: fullName, image: image, dateOfBirth: dateOfBirth, email: email, phoneNumber: phoneNumber, gender: gender, password: password))
            }
        })
        
        
    }

    
    @IBAction func btnRegistry(_ sender: UIButton) {
        
        let scr = storyboard?.instantiateViewController(withIdentifier: "RegistrationScreen") as! RegistrationController
        
        present(scr, animated: true, completion: nil)
        
        //navigationController?.pushViewController(scr, animated: true)
        
        
    }
    
    
    @IBAction func btnLogin(_ sender: UIButton) {
        var count = 0
        for user in userData {
            if let userName = txtUserName.text, let password = txtPassword.text {
                if userName == user.userName && password == user.password{
                    count += 1
                    
                    let main = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                    
                    main.userID = user.userID
                    
                    self.view.window?.rootViewController = main
                    self.view.window?.makeKeyAndVisible()
                    
                    /*let alert = UIAlertController(title: "Thông báo", message: "Đăng nhập thành công!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)*/
                }
            }
            else{
                let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa nhập đủ thông tin!", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if count == 0 {
            let alert = UIAlertController(title: "Thông báo", message: "Đăng nhập thất bại!", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
