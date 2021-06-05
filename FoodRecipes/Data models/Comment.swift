//
//  Comment.swift
//  FoodRecipes
//
//  Created by CNTT on 6/2/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit

class Comment{
    var commentID:String
    var congThucID:String
    var userID:String
    var commentText:String
    var commentRating:Int
    
    init(commentID:String, congThucID:String, userID:String, commentText:String, commentRating:Int) {
        self.commentID = commentID
        self.congThucID = congThucID
        self.userID = userID
        self.commentText = commentText
        self.commentRating = commentRating
    }}
