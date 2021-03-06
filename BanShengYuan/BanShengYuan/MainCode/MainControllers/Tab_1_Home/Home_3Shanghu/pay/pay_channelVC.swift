//
//  pay_channelVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/7/21.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

import MBProgressHUD

//"oid":81610978848932101
//price:23300
class pay_channelVC: UIViewController {
    
    var finalPrice:Int?
    var orderID:Int!
    
    var oidList = [String]()
    
    @IBOutlet weak var label_finalPrice: UILabel!
    @IBOutlet weak var imageV_wx: UIImageView!
    @IBOutlet weak var imageV_al: UIImageView!
    var payChanel = 1
    
    //network
    
    let OrderM = orderModel()
    let disposeBag = DisposeBag()
    let modelpayPost = ModelOrderPayPost()
    
    let modelpayListPost = ModelOrdersPayPost()
    
    var arrayPayItems = [ModelOrderlistPayPost]()
    
    
    let modelAccess = ModelOrderPayAccessListPost()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()

        setPageValue()
        
        var arrayAccess = [ModelOrderPayAccessOrdersItem]()
        
        for oid in oidList {
            let payAccessItem = ModelOrderPayAccessOrdersItem()
            payAccessItem.orderId = oid
            
            arrayAccess.append(payAccessItem)
        }
        
        modelAccess.orders = arrayAccess
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(wxaction(notification:)), name: NSNotification.Name(rawValue: "WXorderNotifation"), object: nil)
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(alaction(notification:)), name: NSNotification.Name(rawValue: "ALorderNotifation"), object: nil)
    
        // Do any additional setup after loading the view.
    }
    
    deinit {
        //注销通知
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "WXorderNotifation"), object: nil)
    }
    
    //通知内容接收
    func wxaction(notification: NSNotification) {
        
        PrintFM("微信支付成功")
        self.payAccessOrders()
        
    }
    
    //通知内容接收
    func alaction(notification: NSNotification) {
        
        PrintFM("支付宝支付成功")
        
        self.payAccessOrders()
        
    }
    
    func setPageValue() {
        
        if let price = finalPrice {
            
            let strPrice = "\(price)"
            
            PrintFM("\(strPrice)")
            
            label_finalPrice.text = String.init("¥ \(String(describing: strPrice.fixPrice()))")
        }
        
        PrintFM("oidList = \(oidList)")
    }
    
    func setNavi() {
        let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(actionBack(_:)))
        item.image = UIImage(named: "arrow_left")
        
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.title = "支付"
    }
    
    func actionBack(_ sender: Any) {
        
        let alert = UIAlertController(title: "提示", message: "确认离开收银台？", preferredStyle: .alert)
        
        let calcelAction = UIAlertAction(title: "继续支付", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "确认离开", style: .default, handler: { (UIAlertAction) in
            
            //跳转到订单页
            
            //我的订单
            let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "orderListRootVC") as! orderListRootVC
            self.navigationController?.pushViewController(Vc, animated: true)
            
//            self.navigationController?.popToRootViewController(animated: true)
            
        })
        
        // 添加
        alert.addAction(calcelAction)
        alert.addAction(deleteAction)
        
        // 弹出
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func actionWXPay(_ sender: Any) {
        
//        HUDShowMsgQuick(msg: "微信支付尚未开放", toView: KeyWindow, time: 0.8)
//        return
        
        if WXApi.isWXAppInstalled(){
            payChanel = 102
            imageV_wx.image = UIImage.init(named: "choose_s")
            imageV_al.image = UIImage.init(named: "choose_n")
        }else{
//            HUDShowMsgQuick(msg: "未检测到微信", toView: KeyWindow, time: 0.8)
            HUDtextShow(toview: KeyWindow, msg: "未检测到微信", subMsg: "请选择其他支付方式，完成支付。")
        }

    }
    
    @IBAction func actionAliPay(_ sender: Any) {
        payChanel = 101
        imageV_wx.image = UIImage.init(named: "choose_n")
        imageV_al.image = UIImage.init(named: "choose_s")
        
        PrintFM("")
    }
    
    @IBAction func actionPay(_ sender: Any) {
        
        switch payChanel {
        case 1:
            HUDShowMsgQuick(msg: "请选择一种支付方式", toView: KeyWindow, time: 0.8)
            return
        case 101:
            modelpayPost.pay_ebcode = aliPay_ebcode
            break
        case 102:
            modelpayPost.pay_ebcode = wxPay_ebcode
            break
        default:
            return
        }
        
        arrayPayItems.removeAll()
        
        for oid in oidList {
            let modelpayItem = ModelOrderlistPayPost()
            modelpayItem.orderId = oid
            modelpayItem.pay_ebcode = modelpayPost.pay_ebcode
            
            arrayPayItems.append(modelpayItem)
        }
        
        modelpayListPost.orders = arrayPayItems
        
        OrderM.orderListPay(amodel: modelpayListPost)
            
            .subscribe(onNext: { (result: modelPayPlanBack) in
                
                PrintFM("result\(result)")
                
                if let content = result.data{
                    
                    PrintFM("content = \(content)")
                    
                    //支付宝支付
                    if self.payChanel == 101{
                        
                        AlipaySDK.defaultService().payOrder(content.biz_content, fromScheme: "bsyal", callback: {(result) in
                            
                            if let resulttemp = result{
                                if let status = resulttemp["resultStatus"]{
                                    if (status as! String) == "9000"{
                                        
                                        //                                        HUDShowMsgQuick(msg: "支付成功", toView: KeyWindow, time: 0.8)
                                        
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "ALorderNotifation"), object: nil)
                                        
                                    }else{
                                        HUDShowMsgQuick(msg: "支付失败", toView: KeyWindow, time: 0.8)
                                    }
                                    
                                }
                            }
                            
                        })
                        
                    }
                    
                    //微信支付
                    if self.payChanel == 102{
                        
                        if let wxorder = content.pay_order{
                            
                            let paypost:PayReq = PayReq.init()
                            paypost.openID = wxorder.appid!
                            paypost.partnerId = "\(wxorder.mch_id!)"
                            paypost.prepayId = wxorder.prepay_id!
                            paypost.package = "\(wxorder.package!)"
                            paypost.nonceStr = wxorder.nonce_str!
                            paypost.timeStamp = UInt32(wxorder.timestamp!)!
                            paypost.sign = wxorder.sign!
                            WXApi.send(paypost)
                            
                        }
                        
                    }
                    
                }
                
            },onError:{error in
                
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
        
        
    }
    //old pay
    /*
    @IBAction func actionPay(_ sender: Any) {
        
        switch payChanel {
        case 1:
            HUDShowMsgQuick(msg: "请选择一种支付方式", toView: KeyWindow, time: 0.8)
            return
        case 101:
            modelpayPost.pay_ebcode = aliPay_ebcode
            break
        case 102:
            modelpayPost.pay_ebcode = wxPay_ebcode
            break
        default:
            return
        }
        
        if let oid = self.orderID{
            
            modelpayPost.orderId = "\(oid)"
            modelAccess.orderId = "\(oid)"
        }
        
        OrderM.orderPay(amodel: modelpayPost)
            
            .subscribe(onNext: { (posts: modelPayPlanBack) in

                PrintFM("pictureList\(posts)")

                if let content = posts.data{

                    PrintFM("content = \(content)")
                    
                    //支付宝支付
                    if self.payChanel == 101{
                        
                        AlipaySDK.defaultService().payOrder(content.biz_content, fromScheme: "bsyal", callback: {(result) in
                            
                            if let resulttemp = result{
                                if let status = resulttemp["resultStatus"]{
                                    if (status as! String) == "9000"{
                                        
//                                        HUDShowMsgQuick(msg: "支付成功", toView: KeyWindow, time: 0.8)
                                        
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "ALorderNotifation"), object: nil)
                                        
                                    }else{
                                        HUDShowMsgQuick(msg: "支付失败", toView: KeyWindow, time: 0.8)
                                    }
                                    
                                }
                            }
                            
                        })
                        
                    }

                    //微信支付
                    if self.payChanel == 102{
                        
                        if let wxorder = content.pay_order{
                            
                            let paypost:PayReq = PayReq.init()
                            paypost.openID = wxorder.appid!
                            paypost.partnerId = "\(wxorder.mch_id!)"
                            paypost.prepayId = wxorder.prepay_id!
                            paypost.package = "\(wxorder.package!)"
                            paypost.nonceStr = wxorder.nonce_str!
                            paypost.timeStamp = UInt32(wxorder.timestamp!)!
                            paypost.sign = wxorder.sign!
                            WXApi.send(paypost)
                            
                        }
                        
                    }
                    
                }

            },onError:{error in
                
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
        
        
    }
 
 */
    
    func payAccessOrders(){
        
        OrderM.orderListPayAccess(amodel: modelAccess)
            
            .subscribe(onNext: { (result: ModelOrderPayAccessListBack) in
                
                PrintFM("orderPayAccess = \(result)")
                
                if let content = result.data{
                
                    //我的订单
                    let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "orderListRootVC") as! orderListRootVC
                    self.navigationController?.pushViewController(Vc, animated: true)
                    
                    PrintFM("content = \(String(describing: content.toJSONString()))")
                }
                
            },onError:{error in
                
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
                
            })
            .addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
