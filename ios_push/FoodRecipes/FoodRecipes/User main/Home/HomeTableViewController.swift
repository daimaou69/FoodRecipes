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
