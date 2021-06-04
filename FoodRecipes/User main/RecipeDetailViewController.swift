//
//  RecipeDetailViewController.swift
//  FoodRecipes
//
//  Created by CNTT on 6/2/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class RecipeDetailViewController: UIViewController, UITextViewDelegate {
    
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle!
    var storage:StorageReference!
    
    var userID:String!
    var recipeID:String!
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodIngredients: UITextView!
    @IBOutlet weak var foodProccessing: UITextView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userComment: UITextView!
    @IBOutlet weak var likes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userComment.text = "Nhập bình luận của bạn..."
        userComment.textColor = UIColor.lightGray
        
        userComment.delegate = self
        
        ref = Database.database().reference()
        databaseHandle = ref.child("Recipes").observe(DataEventType.value, with: { (snapshot) in
            guard let values = snapshot.value as? [String:Any] else {return}
            
            for (_, value) in values {
                guard let recipe = value as? [String:Any],
                    let cachCheBien = recipe["cachCheBien"] as? String,
                    let congThucID = recipe["congThucID"] as? String,
                    let hinhAnh = recipe["hinhAnh"] as? String,
                    let luotQuanTam = recipe["luotQuanTam"] as? Int,
                    let nguyenLieu = recipe["nguyenLieu"] as? String,
                    let tenMonAn = recipe["tenMonAn"] as? String,
                    let userID = recipe["userID"] as? String else {
                        continue
                }
                
                if congThucID == self.recipeID {
                    
                    self.storage = Storage.storage().reference().child("FoodImages").child(hinhAnh + ".jpeg")
                    
                    self.storage.downloadURL(completion: { (url, err) in
                        if let error = err {
                            print(error.localizedDescription)
                        }else{
                            if let urlString = url?.absoluteString {
                                self.foodImage.load(urlString)
                            }
                        }
                    })
                    
                    self.foodName.text = tenMonAn
                    self.foodIngredients.text = nguyenLieu
                    self.foodProccessing.text = cachCheBien
                    self.likes.text = "Lượt yêu thích: " + String(luotQuanTam)
                }
            }
        })
        
        databaseHandle = ref.child("User").observe(DataEventType.value, with: { (snapshot) in
            guard let values = snapshot.value as? [String:Any] else {return}
            
            for (_, value) in values {
                guard let user = value as? [String: Any],
                    let userID = user["userID"] as? String,
                    let userName = user["userName"] as? String,
                    let fullName = user["fullName"] as? String,
                    let image = user["image"] as? String
                    else {
                        continue
                }
                
                if userID == self.userID {
                    self.storage = Storage.storage().reference().child("ProfileImages").child(image + ".jpeg")
                    
                    self.storage.downloadURL { (url, err) in
                        if let error = err {
                            print(error.localizedDescription)
                        } else {
                            if let urlString = url?.absoluteString{
                                self.userImage.load(urlString)
                            }
                            
                        }
                    }
                }
            }
        })
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        userComment.text = ""
        userComment.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if userComment.text.isEmpty {
            userComment.text = "Nhập bình luận của bạn..."
            userComment.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
