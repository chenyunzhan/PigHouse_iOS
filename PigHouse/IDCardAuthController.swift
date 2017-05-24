//
//  IDCardAuthController.swift
//  PigHouse
//
//  Created by zhan on 2017/5/22.
//  Copyright © 2017年 zhan. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire

//定义一个协议
protocol AutherDelegate {
    func refreshAuther()
}

class IDCardAuthController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    var delegate : AutherDelegate?

    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var idNoTF: UITextField!
    
    var idCardImageArray = [Dictionary<String, Any>]()

    @IBAction func checkCard(_ sender: Any) {
        
        
        let userDefaults = UserDefaults.standard
        let memberDic = userDefaults.dictionary(forKey: "member")
        
        let parameters: Parameters = [
            "idCardImageArray": self.idCardImageArray,
            "realName": self.nameTF.text!,
            "cardId":self.idNoTF.text!,
            "memberId":memberDic!["id"]!,
            "level":memberDic!["level"]!
        ]
        Alamofire.request(AppDelegate.baseURLString+"/member/idCardAuth", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let JSON = response.result.value {
                
                let resultDic = JSON as! Dictionary<String, Any>
                
                let error = resultDic["error"]
                
                if (error == nil) {
                    
                    let memberDic = resultDic["member"] as! Dictionary<String, Any>
                    
                    let member = ["id":memberDic["id"],"phone":memberDic["phone"],"level":memberDic["level"],"cardImages":memberDic["cardImages"],"cardId":memberDic["cardId"],"realName":memberDic["realName"]]
                    
                    UserDefaults.standard.set(member, forKey: "member");
                    
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.refreshAuther()
                }
            }

        }
        
        
    }
    
    override func viewDidLoad() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.pickerFront(sender:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.pickerFront(sender:)))

        self.frontImageView.addGestureRecognizer(tapGesture1)
        self.frontImageView.isUserInteractionEnabled = true
        self.frontImageView.tag = 10001
        self.backImageView.addGestureRecognizer(tapGesture2)
        self.backImageView.isUserInteractionEnabled = true
        self.backImageView.tag = 10002
        
        idCardImageArray.append(Dictionary())
        idCardImageArray.append(Dictionary())


    }
    
    
    func pickerFront(sender:UITapGestureRecognizer?) -> Void {
        
        if(self.cameraPermissions()&&self.isCameraCanUse()) {
            let pickerVC = UIImagePickerController()
            pickerVC.view.backgroundColor = UIColor.white
            pickerVC.view.tag = (sender?.view?.tag)!
            pickerVC.delegate = self
            pickerVC.allowsEditing = true
            pickerVC.sourceType = .camera
            present(pickerVC, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "温馨提示", message: "无法使用相机", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        

    }
    
    
    
    /**
     判断相机权限
     
     - returns: 有权限返回true，没权限返回false
     */
    func cameraPermissions() -> Bool{
        
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            return false
        }else {
            return true
        }
        
    }
    
    
    func isCameraCanUse() -> Bool {
       return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            
            let imageData = UIImageJPEGRepresentation(image, 1)
            let imageStr = imageData?.base64EncodedString()

            if picker.view.tag==10001 {
                
                self.frontImageView.image = image
                let frontImageDic = ["frontImage":imageStr!]
                self.idCardImageArray[0] = frontImageDic
                
                let upAction = "idcard.scan"
                let username = "e0c786ac-8da0-4b97-8ecf-4e94b42fd26d"
                let psd = "IfPLDxioYHNugrvJDkDGRLclvXZTKy";
                let md5Psd = psd.md5().uppercased()
                let deviceType = "aaa"
                let currentTime = "bbb"
                let rand = "ccc";
                let verify = (upAction+username+rand+currentTime+psd).md5().uppercased()
                let fileExt = "png"
                
                let data = String(format: "<action>%@</action><client>%@</client><system>%@</system><password>%@</password><key>%@</key><time>%@</time><verify>%@</verify><ext>%@</ext><type>%@</type><file>%@</file><json>%@</json>", upAction, username, deviceType, md5Psd, rand, currentTime, verify, fileExt,"1", imageStr!,"1")
                
                
                Alamofire.request("http://www.yunmaiocr.com/SrvXMLAPI", method: .post, parameters: [:], encoding: data, headers: [:]).responseJSON { response in
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        let idCardInfo = JSON as! Dictionary<String, Any>
                        let dataDic = idCardInfo["data"] as! Dictionary<String, Any>
                        let itemDic = dataDic["item"] as! Dictionary<String, Any>
                        let name = itemDic["name"] as! String
                        let idNo = itemDic["cardno"] as! String
                        self.nameTF.text = name
                        self.idNoTF.text = idNo
                    }
                }
            } else if (picker.view.tag == 10002) {
                self.backImageView.image = image
                let backImageDic = ["backImage":imageStr!]
                self.idCardImageArray[1] = backImageDic
            }
            
            
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}



extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
