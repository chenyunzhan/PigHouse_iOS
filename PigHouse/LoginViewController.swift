//
//  LoginViewController.swift
//  PigHouse
//
//  Created by zhan on 2017/5/17.
//  Copyright © 2017年 zhan. All rights reserved.
//

import Foundation
import Alamofire


//定义一个协议
protocol HouseDetailDelegate {
    func bookHouse()
}

class LoginViewController: UIViewController {
    
    var delegate : HouseDetailDelegate?

    
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var codeTF: UITextField!
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func getCodeAction(_ sender: Any) {
        
        let phone = phoneTF.text
        
        Alamofire.request(AppDelegate.baseURLString+"/member/getVerificationCode?phone="+phone!).responseJSON { response in
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    
    
    @IBAction func doLoginAction(_ sender: Any) {
        
        let phone = phoneTF.text
        let code = codeTF.text
        
        Alamofire.request(AppDelegate.baseURLString+"/member/doLogin?phone="+phone!+"&code="+code!).responseJSON { response in
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                let resultDic = JSON as! Dictionary<String, Any>
                
                let error = resultDic["error"]
                
                if (error == nil) {
                    let memberDic = resultDic["member"] as! Dictionary<String, Any>
                    
                    let member = ["id":memberDic["id"],"phone":memberDic["phone"],"level":memberDic["level"]]
                    
                    UserDefaults.standard.set(member, forKey: "member");
                    
                    
                    self.dismiss(animated: true, completion: {
                        self.delegate?.bookHouse()
                        
                    })
                }

            }
        }
        
    }
}
