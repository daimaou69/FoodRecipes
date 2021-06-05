//
//  CongThuc.swift
//  FoodRecipes
//
//  Created by CNTT on 5/23/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit

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
