//
//  RegistrationController.swift
//  FoodRecipes
//
//  Created by CNTT on 4/19/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import Firebase


class RegistrationController: UIViewController {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    var userData = [User]()
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    
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
                    let dateOfBirth = user["dateOfBirth"] as? String,
                    let email = user["email"] as? String,
                    let phoneNumber = user["phoneNumber"] as? String,
                    let address = user["address"] as? String,
                    let password = user["password"] as? String else {
                        continue
                }
                
                self.userData.append(User(userID: userID, userName: userName, fullName: fullName, dateOfBirth: dateOfBirth, email: email, phoneNumber: phoneNumber, address: address, password: password))
            }
        })
    }
    
    
    @IBAction func btnRegistry(_ sender: UIButton) {
        
        if let userName = txtUserName.text, let fullName = txtFullName.text,
            let dateOfBirth = txtDateOfBirth.text, let email = txtEmail.text,
            let phoneNumber = txtPhoneNumber.text, let address = txtAddress.text,
            let password = txtPassword.text, let confirm = txtConfirm.text {
            
            if userName != "" && fullName != "" && dateOfBirth != "" && email != "" && phoneNumber != "" && address != "" && password != "" && confirm != "" {
                if userNameCheck(userName: userName, phoneNumber: phoneNumber, email: email, users: userData) == 1 {
                    let alert = UIAlertController(title: "Thông báo", message: "User name đã tồn tại!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else if userNameCheck(userName: userName, phoneNumber: phoneNumber, email: email, users: userData) == 2 {
                    let alert = UIAlertController(title: "Thông báo", message: "Số điện thoại đã tồn tại!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else if userNameCheck(userName: userName, phoneNumber: phoneNumber, email: email, users: userData) == 3 {
                    let alert = UIAlertController(title: "Thông báo", message: "Email đã tồn tại!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    if password == confirm {
                        createUser(userName: userName, fullName: fullName, dateOfBirth: dateOfBirth, email: email, phoneNumber: phoneNumber, address: address, password: password)
                        
                        let alert = UIAlertController(title: "Thông báo", message: "Tạo tài khoản thành công!", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                            let scr = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as! ViewController
                            
                            self.present(scr, animated: true, completion: nil)
                        }))
                        
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        let alert = UIAlertController(title: "Thông báo", message: "Bạn nhập sai mật khẩu!", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            else {
                let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa điền đủ thông tin!", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        
        
    }
    
    @IBAction func btnBackToLogin(_ sender: UIButton) {
        let scr = storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as! ViewController
        
        present(scr, animated: true, completion: nil)
    }
    
    func createUser(userName:String, fullName:String, dateOfBirth:String, email:String, phoneNumber:String, address:String, password:String){
        ref = Database.database().reference()
        
        let id = ref.childByAutoId()
        
        if let userID = id.key {
            self.ref.child("User").child(userID).setValue([
                "userID": userID,
                "userName": userName,
                "fullName": fullName,
                "dateOfBirth": dateOfBirth,
                "email": email,
                "phoneNumber": phoneNumber,
                "address": address,
                "password": password
                ])
        }
    }
    
    func userNameCheck(userName:String, phoneNumber:String, email:String, users:[User]) -> Int{
        for user in users{
            if userName == user.userName {
                return 1
            }
            else if phoneNumber == user.phoneNumber {
                return 2
            }
            else if email == user.email {
                return 3
            }
        }
        return 0
    }
}
