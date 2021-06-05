//
//  EditRecipeViewController.swift
//  FoodRecipes
//
//  Created by CNTT on 5/29/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class EditRecipeViewController: UIViewController {
    
    @IBOutlet weak var imgEditRepice: UIImageView!
    
    @IBOutlet weak var txtFoodName: UITextField!
    
    @IBOutlet weak var txtResouce: UITextField!
    
    @IBOutlet weak var txtHowCook: UITextView!
    
    @IBAction func btnEdit(_ sender: Any) {
    }
    
    var ref:DatabaseReference!
    var storage:StorageReference!
    var databaseHandle:DatabaseHandle!
    
   
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
                    self.txtResouce.text = nguyenLieu
                    self.txtHowCook.text = cachCheBien
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
       
        // Do any additional setup after loading the view.
    }
    func clickimg(){
        
        print("Da click img")
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
