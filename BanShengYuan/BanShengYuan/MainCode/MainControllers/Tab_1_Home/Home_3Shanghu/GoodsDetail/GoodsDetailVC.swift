//
//  GoodsDetailVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import SwiftyJSON

class GoodsDetailVC: BaseTabHiden {
    
    //network
    
    let VipM = shopModel()
    let modelGoodsDetailPost = ModelGoodsDetailPost()
    let modelGoodsDetailPictruePost = ModelGoodsDetailPicturePost()
    let disposeBag = DisposeBag()
    
    var array_banner = NSMutableArray()
    
    let OrderM = orderModel()
    let modelOrderC = ModelOrderCreatePost()
    
    @IBOutlet weak var tableV_main: UITableView!
    
    let array_zDetail = ["zdetail1","zdetail2","zdetail3","zdetail4"]
    
    let array_xDetail = NSMutableArray()
    
    
    var coverVC: chooseVC! = nil
    
    var coverNVC: chooseNoneCoverVC! = nil
    
    var _tapGesture: UITapGestureRecognizer!
    
    var model_goods:ModelShopDetailItem? ///上层商品数据
    var model_shop:ModelShopItem? ///上上层商户数据
    
    var miMgheightdatas:[Int] = []
    
    var isOpen:Bool? = false
    
    var didHight = NSMutableDictionary()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
 
        super.viewDidLoad()

        self.edgesForExtendedLayout = []
        
        tableV_main.register(UINib.init(nibName: "TCellGoodsinfo", bundle: nil), forCellReuseIdentifier: "TCellGoodsinfo")
        tableV_main.register(UINib.init(nibName: "TCellGoodsImage", bundle: nil), forCellReuseIdentifier: "TCellGoodsImage")
        
        tableV_main.estimatedRowHeight = 200
        
//        tableV_main.rowHeight = UITableViewAutomaticDimension
        
        setCoverView()
        
        setCoverViewNone()
        
        getData()
        
    }
    @IBAction func actionBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        
        PrintFM("")
    }
    
    func getData(){
        
        modelGoodsDetailPost.productId = model_goods?.pid
        
        VipM.shopGetDetail(amodel: modelGoodsDetailPost)
            .subscribe(onNext: { (result: ModelGoodsDetailResult) in
                
                PrintFM("ModelGoodsDetailResult\(result)")
                
                if let detailText = result.detailText{
                    
                    PrintFM("array_itemPace = \(detailText.array_itemPace)")
                    
                    self.array_xDetail.addObjects(from: detailText.array_itemPace)
                    
//                    self.tableV_main.reloadData()
                }
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
        
        modelGoodsDetailPictruePost.productId = model_goods?.pid
        modelGoodsDetailPictruePost.type = "banner"
        
        VipM.shopGetDetailPictures(amodel: modelGoodsDetailPictruePost)
            .subscribe(onNext: { (posts: [ModelGoodsDetailResultPictures]) in
                
                PrintFM("pictureList\(posts)")
                
                self.array_banner.removeAllObjects()
                
                self.array_banner.addObjects(from: posts)
                
                self.tableV_main.reloadData()
                
            },onError:{error in
                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
                }else{
                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
                }
            })
            .addDisposableTo(disposeBag)
        
    }
    
    func setCoverView(){
        
        coverVC = StoryBoard_NextPages.instantiateViewController(withIdentifier: "chooseVC") as? chooseVC
        
        coverVC.view.frame = CGRect.init(x: 0, y: 0, width: IBScreenWidth, height: IBScreenHeight)
        
        coverVC.delegate = self
        
        self.view.addSubview(coverVC.view)
        
        self.view.sendSubview(toBack: coverVC.view)
        
    }
    
    func showCoverView() {
        
        self.view.bringSubview(toFront: coverVC.view)
    }
    
    func closeCoverView() {
        
        self.view.sendSubview(toBack: coverVC.view)
    }
    
    func setCoverViewNone(){
        
        coverNVC = StoryBoard_NextPages.instantiateViewController(withIdentifier: "chooseNoneCoverVC") as? chooseNoneCoverVC
        
        coverNVC.view.frame = CGRect.init(x: 0, y: 0, width: IBScreenWidth, height: IBScreenHeight)
        
        coverNVC.delegate = self
        
        self.view.addSubview(coverNVC.view)
        
        self.view.sendSubview(toBack: coverNVC.view)
        
    }
    
    func showCoverViewNone() {
        
        self.view.bringSubview(toFront: coverNVC.view)
    }
    
    func closeCoverViewNone() {
        
        self.view.sendSubview(toBack: coverNVC.view)
    }
    
    //支付
    @IBAction func buyNow(_ sender: Any) {
        
        sendOrder()
        
//        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "GoodsPayVC") as! GoodsPayVC
//        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //提交订单
    
    func sendOrder() {
        
        let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "GoodsPayVC") as! GoodsPayVC
        self.navigationController?.pushViewController(Vc, animated: true)
        
//        modelOrderC.companyId = model_goods?.companyId
//        modelOrderC.shopId = shipid
//        modelOrderC.shopName = model_shop?.storeName
//        modelOrderC.userId = USERM.MemberID
//        modelOrderC.userName = USERM.Phone
//        modelOrderC.phone = USERM.Phone
//        modelOrderC.address = "地址"
//        modelOrderC.longitude = "121.377436"
//        modelOrderC.latitude = "31.267283"
//        modelOrderC.type = 1
//        modelOrderC.status = 1
//        modelOrderC.amount = 1490
//        modelOrderC.payType = 1
//        modelOrderC.payChannel = ""
//        modelOrderC.payChannelName = ""
//        modelOrderC.source = "ios app"
//        modelOrderC.partition = ""
//        modelOrderC.customerOrder = "BSY".OrderIDFromtimeSP
//        modelOrderC.remark = ""
//        
//        let modelproduct = OrderProductItemReq()
//        modelproduct.productId = model_goods?.pid
//        modelproduct.productName = model_goods?.name
//        modelproduct.specification = "茶色 XL"
//        modelproduct.number = "1"
//        modelproduct.price = "990"
//        modelproduct.sequence = "0"
//        
//        modelOrderC.products = [modelproduct]
//        
//        let modelaccount = OrderAccountItemReq()
//        modelaccount.accountId = "account-1"
//        modelaccount.name = "运费"
//        modelaccount.type = "1"
//        modelaccount.price = "500"
//        modelaccount.number = "1"
//        modelaccount.sequence = 0
//        
//        modelOrderC.accounts = [modelaccount]
//        
//        OrderM.orderCreate(amodel: modelOrderC)
//            .subscribe(onNext: { (posts: ModelOrderCreateBack) in
//                
//                PrintFM("pictureList\(posts)")
//                
//                let Vc = StoryBoard_NextPages.instantiateViewController(withIdentifier: "GoodsPayVC") as! GoodsPayVC
//                self.navigationController?.pushViewController(Vc, animated: true)
//                
//            },onError:{error in
//                if let msg = (error as? MyErrorEnum)?.drawMsgValue{
//                    HUDShowMsgQuick(msg: msg, toView: self.view, time: 0.8)
//                }else{
//                    HUDShowMsgQuick(msg: "server error", toView: self.view, time: 0.8)
//                }
//            })
//            .addDisposableTo(disposeBag)
        
    }
    
    
}

extension GoodsDetailVC:chooseNoneCoverVDelegate{
    
    func chooseNoneClose(){
        closeCoverViewNone()
    }
}

extension GoodsDetailVC:ChooseCoverVDelegate{
    
    func setAction(actionType:ChooseCoverActionType){
        switch actionType {
        case .ADD:
            PrintFM("")
        case .Fls:
            PrintFM("")
        case .CLOSE:
            PrintFM("")
            closeCoverView()
        }
    }
    
    func buyNowAction(items:NSArray){
        closeCoverView()
    }
    
}

extension GoodsDetailVC:view_goodsMoreDelegate{
    func goodsMoreOpen(){
        self.isOpen = true
        self.tableV_main.reloadData()
    }
}

extension GoodsDetailVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if section == 2 {
            
//            if self.isOpen == false {
            
                return 44
            
//            }else {
//                return 0
//            }
            
        }else if section == 0{
            return IBScreenWidth*402/375
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        
        if section == 0 {
            
            let imageArray = ["banner1","banner2","banner3"]
            
            let viewheader = view_shanghuHeader.init(frame: CGRect.init(x: 0, y: 0, width: IBScreenWidth, height: IBScreenWidth*402/375))
            
            viewheader.isscroll = false
            
            
            viewheader.contentImages = {
                
                return imageArray
            }
            
            return viewheader
            
            
        }else if section == 2{
            
            let viewfooter = Bundle.main.loadNibNamed("view_goodsMore", owner: nil, options: nil)?.first as? view_goodsMore
            
            viewfooter?.delegate = self
            
            return viewfooter
        }else{
            return nil
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 0
        case 1:
            return 1
        case 2:
            
//            return self.isOpen! ? array_xDetail.count : 0
            
//            return array_zDetail.count
            
            return array_xDetail.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellGoodsinfo", for: indexPath) as! TCellGoodsinfo
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.label_name.text = model_goods?.name

            if let price = model_goods?.finalPrice{

                let str = String(describing: price)
                
                cell.label_price.text = String.init("¥ \(String(describing: str.fixPrice()))")
            }
            
            cell.delegate = self
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellGoodsImage", for: indexPath) as! TCellGoodsImage
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
//            let longurl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497878307246&di=2ba97ccfa0be61143a61baa61eee95ba&imgtype=0&src=http%3A%2F%2Fimg.bbs.cnhubei.com%2Fforum%2Fdvbbs%2F2004-4%2F200441915031894.jpg"
            
            let url = URL(string: array_xDetail[indexPath.row] as! String)
            
            cell.imageV_content.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: {image, error, cacheType, imageURL in

//                    self.tableV_main.reloadData()
                
//                let hight =  CGFloat( (image?.size.height)! / (image?.size.width)! * IBScreenWidth )
//                
//                self.didHight.setValue(String(describing: hight), forKey: String.init(format: "index_%d", indexPath.row))
//                
//                PrintFM("size_hight = \(String(describing: image?.size.height)),size_width = \(String(describing: image?.size.width))")
//
                })
        
//            cell.imageV_content.image = BundleImageWithName(array_zDetail[indexPath.row])
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellActivity", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
}


extension GoodsDetailVC: TCellGoodsinfoDelegate {
    
    func setAction(actionType:String){
        showCoverView()
        
//        showCoverViewNone()
    }
    
}

extension GoodsDetailVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
        case 1:
            return 160
        case 2:
            
//            if let image = BundleImageWithName(array_zDetail[indexPath.row]){
//                let hight =  image.size.height / image.size.width * IBScreenWidth
//            
////                PrintFM("imageHight \(hight)")
//                return CGFloat(hight)
//            }else{
//                return 0
//            }
            
//            var hight:CGFloat?
//            
            //计算
            
            let url = URL(string: array_xDetail[indexPath.row] as! String)
            let imageV = UIImageView.init()
            imageV.kf.setImage(with: url)
            
            if self.isOpen == true {
                
                if let image = imageV.image{
                    
                    let hight =  image.size.height / image.size.width * IBScreenWidth
                    
                    return CGFloat(hight)
                }else{
                    return 0
                }
                
            }else{
                
                return 0
            }
            
//            return UITableViewAutomaticDimension
            
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PrintFM("\(indexPath.row)")
        
    }
}
