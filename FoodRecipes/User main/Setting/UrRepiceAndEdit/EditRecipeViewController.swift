//
//  EditRecipeViewController.swift
//  FoodRecipes
//
//  Created by CNTT on 6/9/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class EditRecipeViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var ref:DatabaseReference!
    var storage:StorageReference!
    var databaseHandle:DatabaseHandle!
     var storef: StorageReference!
    
     var imgname:String = ""
    
    @IBOutlet weak var txtHowCook: UITextView!
    @IBOutlet weak var txtResource: UITextField!
    @IBOutlet weak var imgEditRepice: UIImageView!
    @IBOutlet weak var txtFoodName: UITextField!
 
    @IBAction func btnDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Notification", message: "Ban co chac chan xoa ?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            self.ref.root.child("Recipes").child(urRepiceID).removeValue()
            self.storef = Storage.storage().reference().child("FoodImages").child(self.imgname+".jpeg")
            self.storef.delete(completion: { error in
                if let error = error {
                    print(error)
                } else {
                    
                }
            })
            let login = self.storyboard?.instantiateViewController(withIdentifier: "tableRepice") as! ListRecipeTableViewController
            login.tableView.reloadData()
            self.present(login, animated: true, completion: nil)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func btnEdit(_ sender: Any) {
        let alert = UIAlertController(title: "Notification", message: "Ban co chac chan sua ?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            self.ref = Database.database().reference()
            
            
            self.ref.root.child("Recipes").child(urRepiceID).updateChildValues([ "cachCheBien": self.txtHowCook.text])
            self.ref.root.child("Recipes").child(urRepiceID).updateChildValues([ "nguyenLieu": self.txtResource.text])
            
            self.ref.root.child("Recipes").child(urRepiceID).updateChildValues([ "tenMonAn": self.txtFoodName.text])
            let data = self.imgEditRepice.image?.jpegData(compressionQuality: 1.0)
            
            self.ref = Database.database().reference()
            
            let imageName = self.ref.childByAutoId()
            
            if let imgData = data, let imageN = imageName.key {
                
                self.storef = Storage.storage().reference().child("FoodImages").child(imageN + ".jpeg")
                
                self.storef.putData(imgData, metadata: nil) { (metadata, err) in
                    if let error = err {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
            }
            let image = imageName.key
            self.ref.root.child("Recipes").child(urRepiceID).updateChildValues([ "hinhAnh": image])
            
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnChooseImg(_ sender: Any) {
        let alert = UIAlertController(title: "Choose your   ", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Select from library", style: UIAlertAction.Style.default, handler: { action in
            self.imageSource(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        databaseHandle = ref.child("Recipes").observe(DataEventType.value, with: { (snapshot) in
            guard let values = snapshot.value as? [String: Any] else {
                return
            }
            
            
            
            
            for (_, value) in values {
                guard let user = value as? [String: Any],
                    let cachCheBien = user["cachCheBien"] as? String,
                    let congThucID = user["congThucID"] as? String,
                    let hinhAnh = user["hinhAnh"] as? String,
                    let luotQuanTam = user["luotQuanTam"] as? Int,
                    let nguyenLieu = user["nguyenLieu"] as? String,
                    let tenMonAn = user["tenMonAn"] as? String,
                    let userID = user["userID"] as? String else {
                        continue
                }
                
                if urRepiceID == congThucID {
                    self.txtFoodName.text = tenMonAn
                    self.txtResource.text = nguyenLieu
                    self.txtHowCook.text = cachCheBien
                    self.imgname = hinhAnh
                    // hinh anh mon an
                    self.storage = Storage.storage().reference().child("FoodImages").child(hinhAnh + ".jpeg")
                    
                    self.storage.downloadURL { (url, err) in
                        if let error = err{
                            
                        }else{
                            if let urlString = url?.absoluteString{
                                self.self.imgEditRepice.load(urlString)
                            }
                        }
                    }
                }
                
                
            }
        })
        
        
        
        super.viewDidLoad()

        
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
            imgEditRepice.image = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgEditRepice.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func btnBack(_ sender: Any) {
        let login = self.storyboard?.instantiateViewController(withIdentifier: "tableRepice") as! ListRecipeTableViewController
        login.tableView.reloadData()
        self.present(login, animated: true, completion: nil)
    }
    

}
