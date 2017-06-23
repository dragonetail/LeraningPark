//
//  UserCenter_RootVC.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/9.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class UserCenter_RootVC: UIViewController {
    @IBOutlet weak var TableV_main: UITableView!
    
    let array_title:Array? = ["我的订单","我的地址","我的资料"]
    let array_image:Array? = ["homeList_icon","homeList_icon","homeList_icon"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        self.view.backgroundColor = FlatWhiteLight
        
        self.navigationItem.title = "我的"
        
        TableV_main.register(UINib.init(nibName: "TCell_User", bundle: nil), forCellReuseIdentifier: "TCell_User")
        
        TableV_main.backgroundColor = UIColor.white
        
        TableV_main.tableFooterView = UIView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension UserCenter_RootVC:UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return (section==0) ? IBScreenWidth*176/375 : 0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        if section == 0 {
            let dic = ["name":"BSH0002","url":urlStr,"phone":"156****3631"]
            
            let viewheader = Bundle.main.loadNibNamed("view_userHeader", owner: nil, options: nil)?.first as? view_userHeader
            
            viewheader?.usercontent = {
                
                return dic
            }
            
            return viewheader
        }
        
        return nil
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 0
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCell_User", for: indexPath) as! TCell_User
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.label_title.text = array_title?[indexPath.row]
            
            cell.imageV_icon.image = IBImageWithName((array_image?[indexPath.row])!)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCellActivity", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
}

extension UserCenter_RootVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        switch indexPath.section {
        case 1:
            return 44
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            //我的订单
            let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "user_OrderVC") as! user_OrderVC
            self.navigationController?.pushViewController(Vc, animated: true)
        case 1:
            //我的地址
            let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "user_AddressVC") as! user_AddressVC
            self.navigationController?.pushViewController(Vc, animated: true)
        case 2:
            //我的资料
            let Vc = StoryBoard_UserCenter.instantiateViewController(withIdentifier: "user_infoVC") as! user_infoVC
            self.navigationController?.pushViewController(Vc, animated: true)
            
        default:
            return
        }
        
        
        PrintFM("\(indexPath.row)")
        
    }
}
