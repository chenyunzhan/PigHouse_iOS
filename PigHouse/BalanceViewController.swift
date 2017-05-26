//
//  APViewController.swift
//  PigHouse
//
//  Created by zhan on 2017/5/25.
//  Copyright © 2017年 zhan. All rights reserved.
//

import Foundation
import Alamofire


class BalanceViewController: UIViewController {
    
    var orderString: String!

    
    @IBAction func payBalance(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard
        let memberDic = userDefaults.dictionary(forKey: "member")
        let memberId = memberDic?["id"] as! Int
        
        Alamofire.request(AppDelegate.baseURLString+"/order/orderEncode?memberId="+String(memberId)).responseJSON { response in
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let orderEncodeDic = JSON as! Dictionary<String, Any>
                self.orderString = orderEncodeDic["orderString"] as! String
                
                self.doAlipayPay()
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        
    }
    
    
    func doAlipayPay() -> Void {
        
        AlipaySDK.defaultService().payOrder(self.orderString, fromScheme: "alisdkdemo") { (resultDic) in
            print(resultDic!)
        }
    }
}
