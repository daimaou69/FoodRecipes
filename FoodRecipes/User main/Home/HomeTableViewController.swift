//
//  HomeTableViewController.swift
//  FoodRecipes
//
//  Created by CNTT on 5/23/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class HomeTableViewController: UITableViewController, UISearchBarDelegate {

    
    @IBOutlet var recipesTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var storef: StorageReference!
    
    var userID:String!
    var recipesList = [CongThuc]()
    var searchRecipe = [CongThuc]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()
        /*let ct1 = CongThuc(congThucID: "JHJWFBKUJFSB", userID: "daimaou69", tenMon: "Mon Ngon", nguyenLieu: "Thit trau, thit heo, thit ga", cachCheBien: "jkfhgbgdfgjihdtghjidfhuihdfujdfhjidfgkh", hinhAnh: "uyHJBEHJFGHJKEBFIGH", luotQuanTam: 5)
        recipesList.append(ct1)
        
        let ct2 = CongThuc(congThucID: "15FGG55GGG5", userID: "tuan", tenMon: "Heo xao xa ot", nguyenLieu: "HJJADBHJ, UJYYGDHJGBJ, shjgbsdghu", cachCheBien: "hdfgjdfjddrthjAJGHVDFHJVUGSFVU", hinhAnh: "uyHJBEHJFGHJKEBFIGH", luotQuanTam: 0)
        recipesList.append(ct2)*/
        
        ref = Database.database().reference()
        databaseHandle = ref.child("Recipes").observe(DataEventType.value, with: { (snapshot) in
            guard let values = snapshot.value as? [String: Any] else {
                return
            }
            
            self.recipesList = [CongThuc]()
            
            for (_, value) in values {
                guard let recipe = value as? [String: Any],
                    let cachCheBien = recipe["cachCheBien"] as? String,
                    let congThucID = recipe["congThucID"] as? String,
                    let hinhAnh = recipe["hinhAnh"] as? String,
                    let luotQuanTam = recipe["luotQuanTam"] as? Int,
                    let nguyenLieu = recipe["nguyenLieu"] as? String,
                    let tenMonAn = recipe["tenMonAn"] as? String,
                    let userID = recipe["userID"] as? String else {
                        continue
                }
                
                self.recipesList.append(CongThuc(congThucID: congThucID, userID: userID, tenMon: tenMonAn, nguyenLieu: nguyenLieu, cachCheBien: cachCheBien, hinhAnh: hinhAnh, luotQuanTam: luotQuanTam))
                
                self.searchRecipe = self.recipesList
                
                self.tableView.reloadData()
            }
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    

    func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchRecipe = recipesList
            self.tableView.reloadData()
            return
        }
        searchRecipe = recipesList.filter({ (recipe) -> Bool in
            recipe.tenMon.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //println(tasks[indexPath.row])
        
        
        
        let src = storyboard?.instantiateViewController(withIdentifier: "RecipeDetailNavigationController") as! RecipeDetailNavigationController
        
        let recipeDetail = src.viewControllers.first as! RecipeDetailViewController
        
        recipeDetail.recipeID = recipesList[indexPath.row].congThucID
        
        recipeDetail.userID = userID
        
        present(src, animated: true, completion: nil)
        
        
        
        /*let alert = UIAlertController(title: "Test", message: recipesList[indexPath.row].tenMon, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)*/
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchRecipe.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipeCell = "RecipeViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: recipeCell, for: indexPath) as? HomeTableViewCell{
            
            let recipe = searchRecipe[indexPath.row]
            
            self.storef = Storage.storage().reference().child("FoodImages").child(recipe.hinhAnh + ".jpeg")
            
            self.storef.downloadURL { (url, err) in
                if let error = err{
                    print(error.localizedDescription)
                }else{
                    if let urlString = url?.absoluteString{
                        cell.foodIMG.load(urlString)
                    }
                }
            }
            
            cell.recipeName.text = recipe.tenMon
            cell.likes.text = String(recipe.luotQuanTam)
            ref = Database.database().reference()
            databaseHandle = ref.child("User").observe(DataEventType.value, with: { (snapshot) in
                guard let values = snapshot.value as? [String: Any] else {
                    return
                }
                
                for(_, value) in values{
                    guard let user = value as? [String: Any],
                        let userID = user["userID"] as? String,
                        let userName = user["userName"] as? String else {
                            continue
                    }
                    if recipe.userID == userID{
                        cell.posterName.text = "Người đăng: " + userName
                    }
                }
                
            })
            
            
            return cell
        }
        else{
            fatalError("Can not retrieve cell data")
        }
    }
    

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
