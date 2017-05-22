//
//  IDCardAuthController.swift
//  PigHouse
//
//  Created by zhan on 2017/5/22.
//  Copyright © 2017年 zhan. All rights reserved.
//

import Foundation
import AVFoundation


class IDCardAuthController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.pickerFront))
        self.frontImageView.addGestureRecognizer(tapGesture)
        self.frontImageView.isUserInteractionEnabled = true
    }
    
    
    func pickerFront() -> Void {
        
        if(self.cameraPermissions()&&self.isCameraCanUse()) {
            let pickerVC = UIImagePickerController()
            pickerVC.view.backgroundColor = UIColor.white
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
    
}
