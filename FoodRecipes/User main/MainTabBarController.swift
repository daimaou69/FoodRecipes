//
//  MainTabBarController.swift
//  FoodRecipes
//
//  Created by CNTT on 5/5/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    var userID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        guard let viewControllers = viewControllers else{return}
        
        for vc in viewControllers{
            if let settingNav = vc as? SettingNavigationController{
                if let settingView = settingNav.viewControllers.first as? SettingViewController{
                    settingView.userID = userID
                }
            }
            if let homeNav = vc as? HomeNavigationController{
                if let homeView = homeNav.viewControllers.first as? HomeViewController{
                    homeView.userID = userID
                }
            }
            if let newRecipeNav = vc as? NewRecipeNavigationController{
                if let newRecipeView = newRecipeNav.viewControllers.first as? NewRecipeViewController{
                    newRecipeView.userID = userID
                }
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
