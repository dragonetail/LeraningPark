//
//  View_payHeader.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/29.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class View_payHeader: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var bton_adsEdit: UIButton!
    
    @IBOutlet weak var label_orderid: UILabel!
    
    @IBOutlet weak var label_name_phone: UILabel!
    
    @IBOutlet weak var label_address: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        setupSubviews()
    }
    
    func setupSubviews(){
        
        
    }

}
