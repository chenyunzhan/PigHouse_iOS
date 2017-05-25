//
//  APViewController.swift
//  PigHouse
//
//  Created by zhan on 2017/5/25.
//  Copyright © 2017年 zhan. All rights reserved.
//

import Foundation


class APViewController: UIViewController {
    override func viewDidLoad() {
        
    }
    
    
    func doAlipayPay() -> Void {
        
        let orderString =  ""
        
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: "alisdkdemo") { (resultDic) in
            
        }
    }
}
