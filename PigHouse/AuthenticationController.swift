//
//  AuthenticationController.swift
//  PigHouse
//
//  Created by zhan on 2017/5/19.
//  Copyright © 2017年 zhan. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift


class AuthenticationController: UIViewController, AutherDelegate {
    
    @IBOutlet weak var cardIDImage: UIImageView!
    
    @IBOutlet weak var balanceImageView: UIImageView!
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cardAuth))
        self.cardIDImage.addGestureRecognizer(tapGesture)
        self.cardIDImage.isUserInteractionEnabled = true
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.payBalance))
        self.balanceImageView.addGestureRecognizer(tapGesture2)
        self.balanceImageView.isUserInteractionEnabled = true
        
        self.refreshAuther()
    }
    
    
    func payBalance() -> Void {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let balanceViewController = storyboard.instantiateViewController(withIdentifier: "BalanceViewController")
        balanceViewController.title = "支付押金"
        self.navigationController?.pushViewController(balanceViewController, animated: true)

    }
    
    
    func cardAuth() -> Void {
        
        let userDefaults = UserDefaults.standard
        let memberDic = userDefaults.dictionary(forKey: "member")
        
        if (memberDic != nil) {
            
            let level = memberDic?["level"] as! String
            
            if Int(level)! == 0 || Int(level)! == 2{
                let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                let idCardAuthController = storyboard.instantiateViewController(withIdentifier: "IDCardAuthController") as! IDCardAuthController
                idCardAuthController.title = "身份证认证"
                idCardAuthController.delegate = self
                self.navigationController?.pushViewController(idCardAuthController, animated: true)
            } else {
                let alertController = UIAlertController(title: "温馨提示", message: "实名认证已经审核通过！", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        

        
        
    }
    
    
    func refreshAuther() {
        
        let userDefaults = UserDefaults.standard
        let memberDic = userDefaults.dictionary(forKey: "member")
        
        
        
        let cardImages = memberDic?["cardImages"]
        
        if(cardImages != nil) {
            let frontImage = (cardImages as! String).components(separatedBy: "-")[0]
            let url = URL(string:  AppDelegate.baseURLString + "/card_images/" + frontImage)
            let placeholderImage = UIImage(named: "WechatIMG3")!
            self.cardIDImage.af_setImage(withURL: url!, placeholderImage: placeholderImage)
        }
        

    }
    
        
    
}



