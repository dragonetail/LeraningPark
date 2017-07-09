//
//  ModelShop.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/3.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper

//MARK:获商户门店列表 postmodel

class ModelShopDetailPost: Reflect {
    /**
     *  商户编号
     *  必传:True
     */
    var shopId:String!
    /**
     *  页数
     *  必传:True int默认10
     */
    var pagesize:Int!
    /**
     *  页号 int默认 1
     *  必传:True
     */
    var pagenumber:Int!
    
}

//MARK:获商户门店列表 backModel

class ModelShopDetailItem: Mappable {
    var barcode: String?
    var category: String?
    var categoryName: String?
    var companyId: String?
    var customerCode: String?
    var finalPrice: Float?
    
    var labelNames: [ModelItemLabel]?
    var name: String?
    var originalPrice: Float?
    var picture: String?
    var pid: String?
    var saleCount: Int?
    
    var sellTimeName: String?
    var specification: String?
    var status: String?
    var type: String?
    var unit: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        barcode <- map["barcode"]
        category <- map["category"]
        categoryName <- map["categoryName"]
        companyId <- map["companyId"]
        customerCode <- map["customerCode"]
        finalPrice <- map["finalPrice"]
        
        labelNames <- map["labelNames"]
        name <- map["name"]
        originalPrice <- map["originalPrice"]
        picture <- map["picture"]
        pid <- map["pid"]
        saleCount <- map["saleCount"]
        
        sellTimeName <- map["sellTimeName"]
        specification <- map["specification"]
        status <- map["status"]
        type <- map["type"]
        unit <- map["unit"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

// labelItem

class ModelItemLabel: Mappable {
    var lid: Int?
    var shopId: String?
    var name: String?
    var type: Int?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        lid <- map["lid"]
        shopId <- map["shopId"]
        name <- map["name"]
        type <- map["type"]
    }
    
    public var description: String {
        return "shopID: \(String(describing: self.shopId))"
    }
    
}


//MARK:获取商品详情 postmodel

class ModelGoodsDetailPost: Reflect {

    /**
     *  商户编号
     *  必传:True Y 36 string
     */
    var productId:String!

    
}

//MARK:获取商品详情 backModel

class ModelGoodsDetailResult: Mappable {
    var pid: CLongLong?
    var detailText: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        pid <- map["pid"]
        detailText <- map["detailText"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:获取商品详情 图片 postmodel

class ModelGoodsDetailPicturePost: Reflect {
    
    /**
     *  商品ID
     *  必传:True
     */
    var productId:String!
    /**
     *  图片类型
     *  必传:True 默认default，轮播banner
     */
    var type:String!
    
    
}

//MARK:获取商品详情 backModel


class ModelGoodsDetailResultPictures: Mappable {
    var ppid: CLongLong?
    var productId: String?
    var type: CLongLong?
    var url: String?
    var sequence: CLongLong?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        ppid <- map["ppid"]
        productId <- map["productId"]
        type <- map["type"]
        url <- map["url"]
        sequence <- map["sequence"]
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}


