//
//  SavedRecipe.swift
//  FoodRecipes
//
//  Created by CNTT on 6/2/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class SavedRecipeViewController: UITableViewController
{
    var listdatatemp = ["first","Second","Third"]
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var storef: StorageReference!
    
    @IBOutlet var tableview: UITableView!
    var userID:String!
    var recipesList = [CongThuc]()
    var searchRecipe = [CongThuc]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello")
        print("User ID is " + userID)
        
        tableview.dataSource = self
        tableview.delegate = self
       

        let nib = UINib(nibName: "SavedRecipeCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "SavedRecipeCell")
        
        ref = Database.database().reference()
        databaseHandle = ref.child("Recipes").observe(DataEventType.value, with: { (snapshot) in
            guard let values = snapshot.value as? [String: Any] else {
                return
            }
            
            
            self.recipesList = [CongThuc]()
            
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
                
                if self.userID == userID {
                    print(userID)
                    print(tenMonAn)
                    
               self.recipesList.append(CongThuc(congThucID: congThucID, userID: userID, tenMon: tenMonAn, nguyenLieu: nguyenLieu, cachCheBien: cachCheBien, hinhAnh: hinhAnh, luotQuanTam: luotQuanTam))
                    
                    self.searchRecipe = self.recipesList
                    
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listdatatemp.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipeCell = "SavedRecipeCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: recipeCell, for: indexPath) as? SavedRecipeCell{

//            let recipe = listdatatemp[indexPath.row]

//            self.storef = Storage.storage().reference().child("FoodImages").child(recipe.hinhAnh + ".jpeg")

//            self.storef.downloadURL { (url, err) in
//                if let error = err{
//
//                }else{
//                    if let urlString = url?.absoluteString{
//                        cell.imgInfoRecipe.load(urlString)
//                    }
//                }
//            }

            cell.lblRepiceName.text = listdatatemp[indexPath.row]
            cell.imgInfoRecipe.backgroundColor = .red
        
            
            
            return cell
        }
        else{
            fatalError("Can not retrieve cell data")
        }
        
       
    
    }
    



}
