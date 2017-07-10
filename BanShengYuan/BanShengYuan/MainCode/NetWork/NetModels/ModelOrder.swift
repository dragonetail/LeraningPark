//
//  ModelOrder.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/10.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import Foundation


import Foundation
import ObjectMapper

//MARK:创建订单 postmodel

class ModelOrderCreatePost: Reflect {
    /**
     *  商户ID
     *  必传:True 
     */
    var companyId:String!
    /**
     *  门店ID
     *  必传:True
     */
    var shopId:String!
    /**
     *  门店名称
     *  必传:True
     */
    var shopName:String!
    /**
     *  用户ID
     *  必传:True
     */
    var userId:String!
    
    /**
     *  用户名称
     *  必传:True 
     */
    var userName:String!
    /**
     *  用户电话
     *  必传:false
     */
    var phone:String!
    /**
     *  收货地址
     *  必传:false
     */
    var address:String!
    /**
     *  订单类型
     *  必传:True
     */
    var type:Int!
    
    /**
     *  订单状态
     *  必传:True
     */
    var status:Int!
    /**
     *  支付状态
     *  必传:false
     */
    var payStatus:Int!
    /**
     *  支付类型
     *  必传:True
     */
    var payType:Int!
    
    /**
     *  商品列表
     *  必传:True
     */
    var products: [ModelOrderProductItem]?
    
    /**
     *  其他结算列表
     *  必传:True
     */
    var accounts: [ModelOrderAccountItem]?
    
}

class ModelOrderProductItem: Reflect {
    /**
     *  商品ID
     *  必传:True
     */
    var productId:String!
    /**
     *  商品名称
     *  必传:True
     */
    var productName:String!
    /**
     *  商品数量
     *  必传:True
     */
    var number:Int!
    /**
     *  商品单价分
     *  必传:True
     */
    var price:String!
    /**
     *  排序
     *  必传:True
     */
    var sequence:String!
}

class ModelOrderAccountItem: Reflect {
    /**
     *  结算对象ID
     *  必传:True
     */
    var accountId:String!
    /**
     *  结算对象名称
     *  必传:True
     */
    var name:String!
    /**
     *  结算对象类型
     *  必传:True
     */
    var type:Int!
    /**
     *  结算金额
     *  必传:True
     */
    var price:Int!
    /**
     *  结算数量
     *  必传:True
     */
    var number:Int!
    /**
     *  排序
     *  必传:True
     */
    var sequence:Int!
}



//MARK:创建订单返回 backModel

class ModelOrderCreateBack: Mappable {
    var order_id: String?//订单编号
    var payNo: String?//支付编号
    var callBackUrl: String?//支付回调地址
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        order_id <- map["order_id"]
        payNo <- map["payNo"]
        callBackUrl <- map["callBackUrl"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}


//MARK:订单支付 postmodel

class ModelOrderPayPost: Reflect {
    /**
     *  订单ID
     *  必传:True
     */
    var orderId:String!
    /**
     *  支付渠道编码
     *  必传:True 
     */
    var pay_ebcode:String!
    /**
     *  交易编号，用订单号
     *  必传:True int默认10
     */
    var transId:Int!
    
}

//MARK:订单支付 backModel

class ModelOrderPayBack: Mappable {
    var StatusCode: String?//支付状态码
    var payAcount: String?//支付账户
    var payId: String?//支付方式描述
    var msg: String?//返回支付信息
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        StatusCode <- map["StatusCode"]
        payAcount <- map["payAcount"]
        payId <- map["payId"]
        msg <- map["msg"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:订单支付确认 postmodel

class ModelOrderPayAccessPost: Reflect {
    /**
     *  订单ID
     *  必传:True 
     */
    var orderId:String!
    /**
     *  客户要求数，传0
     *  必传:True 
     */
    var clientReqCount:String!
    /**
     *  交易编号，用订单号
     *  必传:True int默认10
     */
    var transId:Int!
    
}

//MARK:订单支付确认 backModel

class ModelOrderPayAccessBack: Mappable {
    var StatusCode: String?//支付状态码
    var payAcount: String?//支付账户
    var payId: String?//支付方式描述
    var msg: String?//返回支付信息
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        StatusCode <- map["StatusCode"]
        payAcount <- map["payAcount"]
        payId <- map["payId"]
        msg <- map["msg"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}


//MARK:订单接单 postmodel

class ModelOrderAcceptPost: Reflect {
    /**
     *  订单ID
     *  必传:True 
     */
    var orderId:String!
    
}

//MARK:订单支付确认 postmodel

class ModelListPageByUserPost: Reflect {
    /**
     *  订单ID
     *  必传:True
     */
    var orderId:String!
    /**
     *  分页大小
     *  必传:True
     */
    var pageSize:Int!
    /**
     *  分页数
     *  必传:True
     */
    var pageNumber:Int!
    
}

//MARK:订单支付确认 backModel

class ModelListPageByUserBack: Mappable {
    var oid: String?//订单ID
    var companyId: String?//商户ID
    var shopId: String?//门店ID
    var shopName: String?//门店名称
    
    var userId: String?//用户ID
    var userName: String?//用户名称
    var phone: String?//用户电话
    var address: String?//收货地址
    
    var longitude: String?//收货地址经度
    var latitude: String?//收货地址纬度
    var type: String?//订单类型
    var status: String?//订单状态
    
    var amount: String?//订单金额(分)
    var payType: String?//支付金额
    var payChannel: String?//支付渠道
    var payChannelName: String?//支付渠道名称
    
    var source: String?//订单来源
    var partition: String?//拆单信息
    var customerOrder: String?//第三方订单编号
    var remark: String?//订单备注
    
    var products: [ModelListPageByUserProductItem]?//商品列表
    var accounts: [ModelListPageByUserAccountItem]?//其他结算列表
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        oid <- map["oid"]
        companyId <- map["companyId"]
        shopId <- map["shopId"]
        shopName <- map["shopName"]
        
        userId <- map["userId"]
        userName <- map["userName"]
        phone <- map["phone"]
        address <- map["address"]
        
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        type <- map["type"]
        status <- map["status"]
        
        amount <- map["amount"]
        payType <- map["payType"]
        payChannel <- map["payChannel"]
        payChannelName <- map["payChannelName"]
        
        source <- map["source"]
        partition <- map["partition"]
        customerOrder <- map["customerOrder"]
        remark <- map["remark"]
        
        products <- map["products"]
        accounts <- map["accounts"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

class ModelListPageByUserProductItem: Mappable {
    var productId: String?//商品ID
    var productName: String?//商品名称
    var number: String?//商品数量
    var specification: String?//商品规格
    
    var price: String?//商品单价分
    var sequence: String?//排序
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        productId <- map["productId"]
        productName <- map["productName"]
        number <- map["number"]
        specification <- map["specification"]
        
        price <- map["price"]
        sequence <- map["sequence"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}

//MARK:订单支付确认 backModel

class ModelListPageByUserAccountItem: Mappable {
    var accountId: String?//结算对象ID
    var name: String?//结算对象名称
    var type: String?//结算对象类型
    var price: String?//结算金额
    
    var number: String?//结算数量
    var sequence: String?//排序
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        accountId <- map["accountId"]
        name <- map["name"]
        type <- map["type"]
        price <- map["price"]
        
        number <- map["number"]
        sequence <- map["sequence"]
        
    }
    
    public var description: String {
        return self.toJSONString()!
    }
    
}