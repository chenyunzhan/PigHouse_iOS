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


class AuthenticationController: UIViewController {
    
    @IBOutlet weak var cardIDImage: UIImageView!
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cardAuth))
        self.cardIDImage.addGestureRecognizer(tapGesture)
        self.cardIDImage.isUserInteractionEnabled = true
    }
    
    
    func cardAuth() -> Void {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let idCardAuthController = storyboard.instantiateViewController(withIdentifier: "IDCardAuthController")
        idCardAuthController.title = "身份证认证"
        self.navigationController?.pushViewController(idCardAuthController, animated: true)
        
        
    }
        
        
    
}



