//
//  RegistrationController.swift
//  FoodRecipes
//
//  Created by CNTT on 4/19/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class RegistrationController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var storef: StorageReference!
    
    var userData = [User]()
    var gender:String = ""
    
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    @IBOutlet weak var profileIMG: UIImageView!
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    //@IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    
    private var datePicker:UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /*profileIMG.layer.cornerRadius = profileIMG.frame.width / 2
        profileIMG.clipsToBounds = true
        profileIMG.layer.borderColor = UIColor.black.cgColor
        profileIMG.layer.borderWidth = 1*/
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(RegistrationController.dateChanged(datePicker:)), for: .valueChanged)
        
        /*let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)*/
        
        txtDateOfBirth.inputView = datePicker
        
        ref = Database.database().reference()
        databaseHandle = ref.child("User").observe(DataEventType.value, with: { (snapshot) in
            guard let values = snapshot.value as? [String: Any] else {
                return
            }
            
            self.userData = [User]()
            
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
                
                self.userData.append(User(userID: userID, userName: userName, fullName: fullName, image: image, dateOfBirth: dateOfBirth, email: email, phoneNumber: phoneNumber, gender: gender, password: password))
            }
        })
    }
    
    /*@objc func viewTapped( gestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }*/
    
    
    @IBAction func btnCheckTapped(_ sender: UIButton) {
        sender.isSelected = true
        gender = "Male"
        if btnFemale.isSelected == true {
            btnFemale.isSelected = false
        }
    }
    
    
    @IBAction func btnFCheckTapped(_ sender: UIButton) {
        sender.isSelected = true
        gender = "Female"
        gender = "Female"
        if btnMale.isSelected == true {
            btnMale.isSelected = false
        }
    }
    
    @objc func dateChanged(datePicker:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        txtDateOfBirth.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    @IBAction func btnImageSelect(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose your   ", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Select from library", style: UIAlertAction.Style.default, handler: { action in
            self.imageSource(sourceType: .photoLibrary)
        }))
        /*alert.addAction(UIAlertAction(title: "Take new photo", style: UIAlertAction.Style.default, handler: { action in
            self.imageSource(sourceType: .camera)
        }))*/
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imageSource(sourceType: UIImagePickerController.SourceType){
    
        let image = UIImagePickerController()
        image.delegate = self
        image.allowsEditing = true
        image.sourceType = sourceType
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileIMG.image = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileIMG.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnRegistry(_ sender: UIButton) {
        
        if let userName = txtUserName.text, let fullName = txtFullName.text,
            let dateOfBirth = txtDateOfBirth.text, let email = txtEmail.text,
            let phoneNumber = txtPhoneNumber.text,
            let password = txtPassword.text, let confirm = txtConfirm.text {
            
            if userName != "" && fullName != "" && dateOfBirth != "" && email != "" && phoneNumber != "" && self.gender != "" && password != "" && confirm != "" {
                if userNameCheck(userName: userName, phoneNumber: phoneNumber, email: email, users: userData) == 1 {
                    let alert = UIAlertController(title: "Thông báo", message: "User name đã tồn tại!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }else if userNameCheck(userName: userName, phoneNumber: phoneNumber, email: email, users: userData) == 2 {
                    let alert = UIAlertController(title: "Thông báo", message: "Số điện thoại đã tồn tại!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }else if userNameCheck(userName: userName, phoneNumber: phoneNumber, email: email, users: userData) == 3 {
                    let alert = UIAlertController(title: "Thông báo", message: "Email đã tồn tại!", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }else{
                    if password == confirm {
                        let alert = UIAlertController(title: "Xác nhận", message: "Xác nhận đúng thông tin và đăng ký?", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                            
                            self.createUser(userName: userName, fullName: fullName, dateOfBirth: dateOfBirth, email: email, phoneNumber: phoneNumber, gender: self.gender, password: password)
                            
                            let alert = UIAlertController(title: "Thông báo", message: "Tạo tài khoản thành công!", preferredStyle: UIAlertController.Style.alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                                let scr = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as! ViewController
                                
                                self.present(scr, animated: true, completion: nil)
                            }))
                            
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }))
                        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }else{
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
    
    func createUser(userName:String, fullName:String, dateOfBirth:String, email:String, phoneNumber:String, gender:String, password:String){

        /*guard let image = profileIMG.image,
            let data = image.jpegData(compressionQuality: 1.0) else {
            let alert = UIAlertController(title: "Error", message: "Error uploading photo!", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }*/
        
        let data = profileIMG.image?.jpegData(compressionQuality: 1.0)
        
        ref = Database.database().reference()
        
        let imageName = ref.childByAutoId()
        
        if let imgData = data, let imageN = imageName.key {
            
            storef = Storage.storage().reference().child("ProfileImages").child(imageN + ".jpeg")
            
            /*let uploadTask = storef.putData(imgData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                
            }*/
            
            storef.putData(imgData, metadata: nil) { (metadata, err) in
                if let error = err {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        
        let id = ref.childByAutoId()
        
        if let userID = id.key, let imageN = imageName.key {
            self.ref.child("User").child(userID).setValue([
                "userID": userID,
                "userName": userName,
                "fullName": fullName,
                "image": imageN,
                "dateOfBirth": dateOfBirth,
                "email": email,
                "phoneNumber": phoneNumber,
                "gender": gender,
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
