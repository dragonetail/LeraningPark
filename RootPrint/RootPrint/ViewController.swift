//
//  ViewController.swift
//  RootPrint
//
//  Created by Luofei on 2018/10/24.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

import SVProgressHUD

/// 系统普通字体
var IBFontWithSize: (CGFloat) -> UIFont = {size in
    return UIFont.systemFont(ofSize: size)
}

class ViewController: UIViewController {
    
    var coverItemVC: BLEListVC! = nil
    
    let constCount: Int = 50000 //重复查询次数
    var rtcount: Int = 1 //查询次数记录
    var rtimeCell: TimeInterval = 3 //查询时间间隔
    var rtimer:Timer?
    
    //TODO:弹窗区
    
    var pickSwitch = 0 /// 0 蓝牙设备选择，1 设备打印特性连接
    {
        didSet{
            
        }
    }
    
    var selectedRows = [-1,-1]
    {
        didSet{
            PrintFM("selectedRows = \(selectedRows)")
        }
    }
    
    
    
    @IBOutlet weak var viewCover: UIView!
    @IBOutlet weak var viewPicker: UIPickerView!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    
    @IBOutlet weak var btonNext:UIButton!
    @IBOutlet weak var btonLeft:UIButton!
    
    //蓝牙设备名称集合
    var arrayBlets = [String]()
    {
        didSet{
            viewPicker.reloadAllComponents()
        }
    }
    //选中蓝牙设备可写入协议
    var arrayChas = [String]()
    {
        didSet{
            viewPicker.reloadAllComponents()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        closePicker()
//        setCoverView()
//        NotificationCenter.default.addObserver(self, selector: #selector(removePhoto(noti:)), name: NSNotification.Name(rawValue: BLEDisconnetNoticeName), object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //MARK:单例分离。
    
    func showBlePicker() -> Void {
        showPicker()
        
        IBLVoiceManager.shared.speechWeather(with: "开始设置蓝牙配置")
        
        BLEM.IBSetAutoConnected(true, 4, 4.0)
        
        BLEM.IBBLEDevice { (blets) in
            self.arrayBlets = blets
        }
        
        BLEM.IBBLEChas { (chas) in
            self.arrayChas = chas
        }
        
        BLEM.IBBLEConnectState { (connectstate) in
            
            HUDShowMsgQuick("connectstate \(connectstate.rawValue)", 1)
            switch connectstate{
            case .connected:
                PrintFM("")
                IBLVoiceManager.shared.speechWeather(with: "蓝牙连接成功")
            case .connecting:
                PrintFM("")
            case .disconnecting:
                PrintFM("")
            case .disconnected:
                IBLVoiceManager.shared.speechWeather(with: "蓝牙失去连接")
                PrintFM("")
            }
        }
        
        BLEM.babyScan()
        
    }
    
    
    //MARK:普通弹窗。
    
    @objc fileprivate func removePhoto(noti : Notification) {
        
//        SVProgressHUD.showError(withStatus: "设备连接断开,需要重新连接!!!")
//        
//        HUDShowMsgQuick("设备连接断开,需要重新连接!!!", 1)
//        IBLVoiceManager.shared.speechWeather(with: "设备连接断开,需要重新连接!!!")
//        
//        coverItemVC.reAchive()
//        SVProgressHUD.show()
    }
    
    func showBLEListV() -> Void {
//        print("showBLEListV")
//        showCoverView()
    }
    
    func showBLEChaListV() -> Void {
        print("showBLEChaListV")
    }
    
    func setCoverView(){
        
        coverItemVC = BLEListVC(nibName: "BLEListVC", bundle: nil)
        
        self.addChildViewController(coverItemVC)
        
        coverItemVC.view.frame = self.view.frame
        
        self.view.addSubview(coverItemVC.view)
        
        self.view.sendSubview(toBack: coverItemVC.view)
        
        coverItemVC.view.isHidden = true
        
    }
    
    func showCoverView() {
        
        setBGRun()
        
        coverItemVC.babyScan()
        coverItemVC.view.isHidden = false
        self.view.bringSubview(toFront: coverItemVC.view)
    }
    
    func closeCoverView() {
        coverItemVC.view.isHidden = true
//        self.view.sendSubview(toBack: coverItemVC.view)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showBLEViews(_ sender: Any) {
        
//        (self.navigationController as! RootNaviC).showBLEListV()
//        
//        (self.navigationController as! RootNaviC).showBLEChaListV()
//        switch coverItemVC.BLEChoose.IBLcurrPeripheral?.state {
//        case .disconnected:
//            print("disconnected")
//        default:
//            print("disconnected")
//        }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLEDisconnetNoticeName), object: nil)
//        
//        showBLEListV()
        
        ///弹窗
        
        showBlePicker()
        
//        BLEM.setBGRun()
        
    }
    
    @IBAction func BLEWrite(_ sender: Any) {
        
        if BLEM.isWritting{
            
            BLEM.IBWriteZero(data: PrinterInit())
            
        }else{
            SVProgressHUD.showError(withStatus: "蓝牙连接出了问题!!!")
        }
        
//        BLEM.testChaAdd()
    }
    
    @IBAction func BLEAchive(_ sender: Any) {
//        coverItemVC.reAchive()
//        SVProgressHUD.show()
///弹窗
//        BLEManager.shared.lightBtnAction()
//        BLEM.testAdd()
        
        BLEM.IBReachive()
    }
    
    @IBAction func BLECoredata(_ sender: Any) {
        
//        let tag = (sender as! UIButton).tag
//        
//        switch tag {
//        case 1:
//            IBLFileM.save("fm00003", Date(), .WM_SUCCESS)
//        case 2:
//            IBLFileM.update("fm00003", Date(), .WM_SUCCESS)
//        case 3:
//            let array = IBLFileM.getdate("fm00003")
////            PrintFM("\(array)")
//            
//        default:
//            PrintFM("")
//        }
        
    }
    
    
    func PrinterInit() -> Data {
        let printInfo = HLPrinter.init()
//        let partnerName = "FMPOS"
//        let str1 = "测试电商服务中心(销售单)"
//        printInfo.appendText(partnerName, alignment: HLTextAlignment.center, fontSize: HLFontSize.titleBig)
//        printInfo.appendText(str1, alignment: HLTextAlignment.center)
        printInfo.appendLeftText("品名", middleText: "数量／单价", rightText: "金额", isTitle: true)
//        printInfo.appendLeftText("炝锅素1小包（约27克／包）", middleText: "x2／13.44", rightText: "26.88", isTitle: false)
//        printInfo.appendLeftText("炝锅素毛肚炝锅素毛肚散称1小包（约27克／包）", middleText: "x2／13.44", rightText: "26.88", isTitle: false)
//        printInfo.appendLeftText("炝锅素毛肚炝锅素毛肚炝锅素毛肚散称1小包（约27克／包）", middleText: "x2／13.44", rightText: "26.88", isTitle: false)
        printInfo.appendLeftText("炝锅素毛肚散称1小包（约27克／包）", middleText: "x2／13.44", rightText: "26.88", isTitle: false)
//        printInfo.appendSeperatorLine()
//        printInfo.appendBarCode(withInfo: "SXA1205O58029444238")
//        printInfo.appendQRCode(withInfo: "SXA1205O58029444238_20180931")
//        printInfo.appendSeperatorLine()
        printInfo.appendFooter("非码提供技术支持")
        
        return printInfo.getFinalData()
    }

}

//MARK:弹窗区
extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func showPicker() -> Void {
        
        pickSwitch = 0
        viewPicker.reloadAllComponents()
        
//        viewPicker.selectRow(selectedRows[pickSwitch], inComponent: 0, animated: false)
        
        UIView.animate(withDuration: 0.8) {
            self.viewCover.isHidden = false
            self.bottomSpace.constant = 0
        }
    }
    
    func closePicker() -> Void {
        
        
        btonNext.setTitle("下一步", for: .normal)
        btonLeft.setTitle("取消", for: .normal)
        
        UIView.animate(withDuration: 0.8) {
            self.viewCover.isHidden = true
            self.bottomSpace.constant = -228
        }
    }
    
    @IBAction func PCancelAction(_ sender: Any) {
        
        if pickSwitch == 1 {
            pickSwitch = 0
            viewPicker.reloadAllComponents()
            viewPicker.selectRow(0, inComponent: 0, animated: true)
            
            btonNext.setTitle("下一步", for: .normal)
            btonLeft.setTitle("取消", for: .normal)
        }else{
            closePicker()
        }
        
    }
    
    @IBAction func PNextAction(_ sender: Any) {
        
        if pickSwitch == 0 {
            pickSwitch = 1
            viewPicker.reloadAllComponents()
            viewPicker.selectRow(0, inComponent: 0, animated: true)
            
             if selectedRows[0] != -1{
                BLEM.IBLLinkBLE(deviceIdx: selectedRows[0])
                
                btonNext.setTitle("完成", for: .normal)
                btonLeft.setTitle("上一步", for: .normal)
            }
        }else{
            
            
            if selectedRows[1] != -1{
                
                BLEM.IBLLinkBLE(chaIdx: selectedRows[1])
                
                IBLVoiceManager.shared.speechWeather(with: "开始设置蓝牙特性")
                
                closePicker()
                
                PrintFM("selectedRows = \(selectedRows)")
            }
            
        }
        
    }
    
    
    //设置选择框的列数为3列,继承于UIPickerViewDataSource协议
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //设置选择框的行数为9行，继承于UIPickerViewDataSource协议
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        if pickSwitch == 0 {
            return arrayBlets.count
        }
        
        if pickSwitch == 1 {
            return arrayChas.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedRows[pickSwitch] = row
//        
//        if pickSwitch == 0 {
//            BLEM.IBLLinkBLE(deviceIdx: row)
//        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label=UILabel()
        
        label.font = IBFontWithSize(14)
        label.textColor = .black
        label.textAlignment = NSTextAlignment.center
        
        var value = String()
        
        if pickSwitch == 0 {
            value = arrayBlets[row]
        }
        
        if pickSwitch == 1 {
            value = arrayChas[row]
        }
        
        label.text = String.init(format: "%@", value)
        
        
        return label
    }
    
    //delegate
    //设置列宽
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return IBScreenWidth
    }
    
    //设置行高
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}


extension ViewController{
    ///循环动作编辑区,打开循环动作编辑
    func setBGRun(){
        
        if rtimer != nil {
            rtcount = 1
        }else{
            rtimer = Timer.init(fireAt: NSDate() as Date, interval: rtimeCell, target: self, selector: #selector(rtpick), userInfo: nil, repeats: true)
            
            RunLoop.current.add(rtimer!, forMode:RunLoopMode.commonModes)
        }
    }
    
    fileprivate func releasepick(){
        rtimer?.invalidate()
        rtimer = nil
        rtcount = 1
    }
    
    func rtpick() {
        
        rtcount = rtcount%constCount
        
        if rtcount>constCount {
            rtimer?.invalidate()
            rtimer = nil
            rtcount = 1
        }else{
            rtcount += 1
            scrollRoundPlace()
        }
        
    }
    
    ///循环动作编辑区
    fileprivate func scrollRoundPlace(){
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        guard let per = coverItemVC.BLEChoose.IBLcurrPeripheral else {
            print("还未选择连接设备")
            return
        }
        
        if per.state == .disconnected {
            HUDShowMsgQuick("设备连接不正常!!!", 1)
        }else{
//            HUDShowMsgQuick("设备连接正常!!!", 1)
        }
        
    }
}



