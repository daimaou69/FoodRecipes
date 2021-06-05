//
//  ListRecipeTableViewController.swift
//  FoodRecipes
//
//  Created by CNTT on 5/29/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

var urRepiceID:String = ""

class ListRecipeTableViewController: UITableViewController {
    
   
    @IBOutlet var tableview: UITableView!
    
   
    var ref:DatabaseReference!
    var storage:StorageReference!
    var databaseHandle:DatabaseHandle!
    var userID:String! = ""
    var user:User? = nil
   
    
     var recipesList = [CongThuc]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
       
        let nib = UINib(nibName: "YourRepiceTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "YourRepiceTableViewCell")
//        print("user id la"+userid)
        userID = userid
        
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
                
//                self.recipesList.append(CongThuc(congThucID: congThucID, userID: userID, tenMon: tenMonAn, nguyenLieu: nguyenLieu, cachCheBien: cachCheBien, hinhAnh: hinhAnh, luotQuanTam: luotQuanTam))
//
                if userid == userID {
                    self.recipesList.append(CongThuc(congThucID: congThucID, userID: userID, tenMon: tenMonAn, nguyenLieu: nguyenLieu, cachCheBien: cachCheBien, hinhAnh: hinhAnh, luotQuanTam: luotQuanTam))
                   
                    self.tableview.reloadData()
//                    print("ten cua user la "+self.userData[0].gender)
//                    self.storage = Storage.storage().reference().child("ProfileImages").child(image + ".jpeg")
                    
                    
//                    self.storage.downloadURL { (url, err) in
//                        if let error = err {
//                            // Handle any errors
//                        } else {
//                            if let urlString = url?.absoluteString{
//                                self.profileIMG.load(urlString)
//                            }
//
//                        }
//                    }
//                    self.lblUserFullName.text = fullName
                }
               
            }
        })
        
        
      
        
        // Do any additional setup after loading the view.*/
    }

    
   

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.recipesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableview.dequeueReusableCell(withIdentifier: "YourRepiceTableViewCell", for: indexPath) as! YourRepiceTableViewCell
        
        let recipe = recipesList[indexPath.row]
        
        self.storage = Storage.storage().reference().child("FoodImages").child(recipe.hinhAnh + ".jpeg")
        
        self.storage.downloadURL { (url, err) in
            if let error = err{
                
            }else{
                if let urlString = url?.absoluteString{
                    cell.imageYourRepice.load(urlString)
                }
            }
        }
        
        cell.lblRepiceName.text = recipesList[indexPath.row].tenMon

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        urRepiceID = recipesList[indexPath.row].congThucID
        let login = self.storyboard?.instantiateViewController(withIdentifier: "EditRecipe") as! EditRecipeViewController
        
        self.present(login, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
