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
        
        
        /*
        
        let upAction = "idcard.scan"
        let username = "e0c786ac-8da0-4b97-8ecf-4e94b42fd26d"
        let psd = "IfPLDxioYHNugrvJDkDGRLclvXZTKy";
        let md5Psd = psd.md5().uppercased()
        let deviceType = "aaa"
        let currentTime = "bbb"
        let rand = "ccc";
        let verify = (upAction+username+rand+currentTime+psd).md5().uppercased()
        let fileExt = "jpg"
        
        
        let image = UIImage(named: "test-idcard.JPG")
        let imageData = UIImageJPEGRepresentation(image!, 1)
        let imageStr = imageData?.base64EncodedString()

        
        let data = String(format: "<action>%@</action><client>%@</client><system>%@</system><password>%@</password><key>%@</key><time>%@</time><verify>%@</verify><ext>%@</ext><type>%@</type><file>%@</file><json>%@</json>", upAction, username, deviceType, md5Psd, rand, currentTime, verify, fileExt,"1", imageStr!,"1")
        
        
        Alamofire.request("http://www.yunmaiocr.com/SrvXMLAPI", method: .post, parameters: [:], encoding: data, headers: [:]).responseJSON { response in
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
        
 
        */
        
    }
        
        
    
}



extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
