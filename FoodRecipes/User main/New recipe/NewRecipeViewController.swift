//
//  NewRecipeViewController.swift
//  FoodRecipes
//
//  Created by CNTT on 5/5/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CongThuc{
    var congThucID:String
    var userID:String
    var tenMon:String
    var nguyenLieu:String
    var cachCheBien:String
    var hinhAnh:String
    var luotQuanTam:Int
    
    init(congThucID:String, userID:String, tenMon:String, nguyenLieu:String, cachCheBien:String, hinhAnh:String, luotQuanTam:Int){
        self.congThucID = congThucID
        self.userID = userID
        self.tenMon = tenMon
        self.nguyenLieu = nguyenLieu
        self.cachCheBien = cachCheBien
        self.hinhAnh = hinhAnh
        self.luotQuanTam = luotQuanTam
    }
}

class NewRecipeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var userID:String!
    var iN:Int = 0
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var storef: StorageReference!
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var txtTenMonAn: UITextField!
    @IBOutlet weak var txtNguyenLieu: UITextField!
    @IBOutlet weak var txtCachCheBien: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnDangCongThuc(_ sender: UIButton) {
        if iN == 0{
            let alert = UIAlertController(title: "Alert", message: "Bạn chưa chọn hình ảnh!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else if let tenMonAn = txtTenMonAn.text, let nguyenLieu = txtNguyenLieu.text, let cachCheBien = txtCachCheBien.text {
            if tenMonAn == "" || nguyenLieu == "" || cachCheBien == "" {
                let alert = UIAlertController(title: "Alert", message: "Bạn chưa điền đủ thông tin!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "", message: "Xác nhận đăng công thức mới?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                    self.createRecipe(userID: self.userID, foodName: tenMonAn, material: nguyenLieu, proccessing: cachCheBien)
                    self.txtTenMonAn.text = ""
                    self.txtNguyenLieu.text = ""
                    self.txtCachCheBien.text = ""
                    self.foodImage.image = UIImage(named: "RecipeImage")
                    self.iN = 0
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addImage(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Choose your image", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Select from library", style: UIAlertAction.Style.default, handler: { action in
            self.iN += 1
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
            foodImage.image = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            foodImage.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func createRecipe(userID:String, foodName:String, material:String, proccessing:String){
        
        let data = foodImage.image?.jpegData(compressionQuality: 1.0)
        
        ref = Database.database().reference()
        
        let imageName = ref.childByAutoId()
        
        if let imgData = data, let imageN = imageName.key {
            
            storef = Storage.storage().reference().child("FoodImages").child(imageN + ".jpeg")
            
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
        
        if let recipeID = id.key, let image = imageName.key {
            self.ref.child("Recipes").child(recipeID).setValue([
                "congThucID": recipeID,
                "userID": userID,
                "tenMonAn": foodName,
                "nguyenLieu": material,
                "cachCheBien": proccessing,
                "hinhAnh": image,
                "luotQuanTam": 0
                ])
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
