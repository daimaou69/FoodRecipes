//
//  SettingViewController.swift
//  FoodRecipes
//
//  Created by CNTT on 5/5/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func load(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class SettingViewController: UIViewController {

    var ref:DatabaseReference!
    var storage:StorageReference!
    var databaseHandle:DatabaseHandle!
    
    var userID:String!
    
    @IBOutlet weak var profileIMG: UIImageView!
    
    @IBOutlet weak var lblUserFullName : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*profileIMG.layer.cornerRadius = profileIMG.frame.width / 2
        profileIMG.clipsToBounds = true
        profileIMG.layer.borderColor = UIColor.black.cgColor
        profileIMG.layer.borderWidth = 1*/
   
        ref = Database.database().reference()
        
        databaseHandle = ref.child("User").observe(DataEventType.value, with: { (snapshot) in
            guard let values = snapshot.value as? [String:Any] else{return}
            
            for (_, value) in values {
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
                
                if self.userID == userID {
                    self.storage = Storage.storage().reference().child("ProfileImages").child(image + ".jpeg")
                    
                    self.storage.downloadURL { (url, err) in
                        if let error = err {
                            // Handle any errors
                        } else {
                            if let urlString = url?.absoluteString{
                                self.profileIMG.load(urlString)
                            }
                            
                        }
                    }
                    self.lblUserFullName.text = fullName
                }
            }
        })
        
        
        
        
    }
    

    
    @IBAction func btnLogout(_ sender: UIButton) {
        let alert = UIAlertController(title: "Thông báo", message: "Bạn muốn đăng xuất?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            
            let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as! ViewController
            
            self.view.window?.rootViewController = login
            self.view.window?.makeKeyAndVisible()
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
