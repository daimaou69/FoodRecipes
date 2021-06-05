//
//  UpdateInfoViewController.swift
//  FoodRecipes
//
//  Created by CNTT on 5/28/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class UpdateInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var ref:DatabaseReference!
    var storage:StorageReference!
    var databaseHandle:DatabaseHandle!

    var userData = [User]()
    var userID:String!
    var password:String = ""
    
    @IBOutlet weak var imgInfo: UIImageView!
    
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtOldPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    
    @IBOutlet weak var btnChooseImg: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnUpdateInfo: UIButton!
    @IBOutlet weak var btnUpdatePassword: UIButton!
    private var datePicker:UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(RegistrationController.dateChanged(datePicker:)), for: .valueChanged)
        txtDateOfBirth.inputView = datePicker
        
        
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
                    let password = user["password"] as? String
                    else {
                        continue
                }
                
                if self.userID == userID {
                    self.storage = Storage.storage().reference().child("ProfileImages").child(image + ".jpeg")
                    
                    self.storage.downloadURL { (url, err) in
                        if let error = err {
                            // Handle any errors
                        } else {
                            if let urlString = url?.absoluteString{
                                self.imgInfo.load(urlString)
                            }
                        }
                    }
                   self.userData.append(User(userID: userID, userName: userName, fullName: fullName, image: image, dateOfBirth: dateOfBirth, email: email, phoneNumber: phoneNumber, gender: gender, password: password))
    
            print(userName)
            self.txtFullname.text = userName
            self.txtDateOfBirth.text = dateOfBirth
            self.txtPhoneNumber.text = phoneNumber
            self.txtEmail.text = email
                    self.password = password
                }
            }
        }
    )}
    
    @objc func dateChanged(datePicker:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        txtDateOfBirth.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    @IBAction func BackToSettingView(_ sender: Any) {
        let main = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        main.userID = userID
        
        self.view.window?.rootViewController = main
        self.view.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func ChooseImage(_ sender: Any) {
        let alert = UIAlertController(title: "Choose your   ", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Select from library", style: UIAlertAction.Style.default, handler: { action in
            self.imageSource(sourceType: .photoLibrary)
        }))
        /*alert.addAction(UIAlertAction(title: "Take new photo", style: UIAlertAction.Style.default, handler: { action in
         self.imageSource(sourceType: .camera)
         }))*/
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)    }
    
    func imageSource(sourceType: UIImagePickerController.SourceType){
        
        let image = UIImagePickerController()
        image.delegate = self
        image.allowsEditing = true
        image.sourceType = sourceType
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imgInfo.image = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgInfo.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func userNameCheck(phoneNumber:String, email:String, users:[User]) -> Int{
        for user in users{
           if phoneNumber == user.phoneNumber {
                return 2
            }
            else if email == user.email {
                return 3
            }
        }
        return 0
    }
    
    func updateInfoUser(fullName:String, dateOfBirth:String, email:String, phoneNumber:String){
        
            self.ref.child(userID).setValue([
                "userID": userID,
                "fullName": fullName,
                "dateOfBirth": dateOfBirth,
                "email": email,
                "phoneNumber": phoneNumber,
                ])
        print("update")
    }
    
    @IBAction func UpdateInfo(_ sender: Any) {
        if let fullName = txtFullname.text,
            let dateOfBirth = txtDateOfBirth.text, let email = txtEmail.text,
            let phoneNumber = txtPhoneNumber.text {
            
            if fullName != "" && dateOfBirth != "" && email != "" && phoneNumber != "" {
                if (phoneNumber.count != 10){
                    let alert = UIAlertController(title: "Thông báo", message: "Dinh dang so dien thoai sai", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                if userNameCheck(phoneNumber: phoneNumber, email: email, users: userData) == 2 {
                    let alert = UIAlertController(title: "Thông báo", message: "Số điện thoại đã tồn tại!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                if userNameCheck(phoneNumber: phoneNumber, email: email, users: userData) == 3 {
                    let alert = UIAlertController(title: "Thông báo", message: "Email đã tồn tại!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                let updateAction = UIAlertAction(title: "Update", style:.default){(_) in
                
                    self.updateInfoUser(fullName: fullName, dateOfBirth: dateOfBirth, email: email, phoneNumber: phoneNumber)
                }
                let main = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                main.userID = self.userID
                self.view.window?.rootViewController = main
                self.view.window?.makeKeyAndVisible()
            } else{
                let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa điền đủ thông tin!", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func UpdatePassword(_ sender: Any) {
        print(password)
       if let oldPass = txtOldPass.text,
            let newPass = txtNewPass.text, let confirmPass = txtConfirmPass.text
        {
            
            if oldPass != "" && newPass != "" && confirmPass != "" {
                if oldPass != password{
                    let alert = UIAlertController(title: "Thông báo", message: "Password sai", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }else if newPass != confirmPass {
                    let alert = UIAlertController(title: "Thông báo", message: "Password moi va Password confirm khong phu hop !!!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("Update password")
                    let main = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                    self.view.window?.rootViewController = main
                    self.view.window?.makeKeyAndVisible()
                }
            }else {
                    let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa điền đủ thông tin!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
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
