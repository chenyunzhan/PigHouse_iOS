//
//  AuthenticationController.swift
//  PigHouse
//
//  Created by zhan on 2017/5/19.
//  Copyright © 2017年 zhan. All rights reserved.
//

import Foundation
import Alamofire


class AuthenticationController: UIViewController {
    
    @IBOutlet weak var cardIDImage: UIImageView!
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cardAuth))
        self.cardIDImage.addGestureRecognizer(tapGesture)
        self.cardIDImage.isUserInteractionEnabled = true
    }
    
    
    func cardAuth() -> Void {
        print("aaaa")
        
        
        
        let data = "<action>idcard.scan</action><client>e0c786ac-8da0-4b97-8ecf-4e94b42fd26d</client><system>系统描述：包括硬件型号和操作系统型号等</system><password>IfPLDxioYHNugrvJDkDGRLclvXZTKy</password><file>二进制文件，文件最大5M</file><ext>jpg</ext><header>1</header><json>1</json>"
        
        Alamofire.request("http://www.yunmaiocr.com/SrvXMLAPI", method: .post, parameters: [:], encoding: data, headers: [:]).responseJSON { response in
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
        
        
        
        
        
        
        
//        Alamofire.request(.POST, "https://something.com" , parameters: Dictionary(), encoding: .Custom({
//            (convertible, params) in
//            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
//            
//            let data = (self.testString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
//            mutableRequest.HTTPBody = data
//            return (mutableRequest, nil)
//        }))
//            
//            
//            .responseJSON { response in
//                
//                
//                print(response.response) 
//                
//                print(response.result)   
//                
//                
//        }
//        
//        
//        let header = ["content-type" : "application/xml"]
//        
//        Alamofire.request("", method: .post, parameters: Dictionary(), encoding: URLEncoding.default, headers: header).responseJSON { response in
//            
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
//        
        
        
        
        
        
        
        
        
        
    }
        
        
    
}



extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
