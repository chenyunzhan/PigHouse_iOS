//
//  HouseDetailController.swift
//  PigHouse
//
//  Created by zhan on 2017/5/12.
//  Copyright © 2017年 zhan. All rights reserved.
//
import Alamofire
import AlamofireImage


class HouseDetailController: UIViewController,HouseDetailDelegate {


    
    
    let imageCount = 4
    
    let roomType = ["主卧","次卧1","次卧2","客厅隔段","餐厅隔段"]

    var house: Dictionary<String, Any>!
    var roomArray: Array<Dictionary<String, Any>>!

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var roomTypeView: UIView!
    
    @IBOutlet weak var roomTypeViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var room: UILabel!
    
    @IBOutlet weak var roomNo: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    override func viewDidLoad() {
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let images = self.house["images"] as? String
        let imageArr = images?.components(separatedBy: "|")

        self.address.text = self.house["address"] as? String
        self.room.text = self.house["room"] as? String
        
        for index in 0..<(imageArr?.count)! {
            
            
            let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * view.frame.width, y: 0, width: view.frame.width, height: scrollView.frame.height))
//            imageView.image = UIImage(named: "WechatIMG\((index+3)%4)")
            
            
            let url = URL(string: AppDelegate.baseURLString + "/house_images/" + (imageArr?[(index+3)%4])!)!
            let placeholderImage = UIImage(named: "WechatIMG3")!
            
            imageView.af_setImage(withURL: url, placeholderImage: placeholderImage)

            
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            scrollView.addSubview(imageView)
            scrollView.delegate = self
            scrollView.contentSize = CGSize(width: view.frame.width * 3, height: 0)
            scrollView.contentOffset = CGPoint(x: view.frame.width, y: 0)
            scrollView.isPagingEnabled = true
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            
            
            pageControl.currentPage = 0
            pageControl.numberOfPages = imageCount
            
            
        }
        
        var count = 0
        var roomTypeOffsetX:CGFloat = 0.0
        var roomTypeViewRealHeight:CGFloat = 0

        var roomTypeButtonX:CGFloat = 0.0
        var roomTypeButtonY:CGFloat = 0.0
        var roomTypeButtonWidth:CGFloat = 0.0
        var roomTypeButtonHeight:CGFloat = 0.0
        
        

        let roomIds = self.mergeRoomIds()
        
        Alamofire.request(AppDelegate.baseURLString+"/room/getRoomsByHouseId?roomsId="+roomIds).responseJSON { response in

            if let JSON = response.result.value {
                print("JSON: \(JSON)")


                let roomArray = JSON as! Array<Dictionary<String, Any>>
                self.roomArray = roomArray
//
                for index in 0 ..< roomArray.count{
                    let roomName = roomArray[index]["roomName"] as! String
                    
                    
                    let roomTypeButton = UIButton()
                    roomTypeButton.tag = 10000 + index
                    roomTypeButton.setTitle(roomName, for: UIControlState.normal)
                    roomTypeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
                    roomTypeButton.layer.cornerRadius = 5
                    roomTypeButton.layer.masksToBounds = true
                    roomTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                    roomTypeButton.backgroundColor = UIColor(colorLiteralRed: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
                    roomTypeButton.addTarget(self, action: #selector(self.chooseRoomType(sender:)), for: UIControlEvents.touchUpInside)
                    let size: CGSize = roomName.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)])
                    roomTypeButtonWidth = size.width+15
                    roomTypeButtonHeight = size.height+12
                    roomTypeButton.frame = CGRect(x: 0, y: 0, width: roomTypeButtonWidth, height: roomTypeButtonHeight)
                    
                    
                    if(index == 0) {
                        roomTypeButtonX = 0
                        roomTypeButton.frame = CGRect(x: roomTypeButtonX, y: 0, width: roomTypeButtonWidth, height: roomTypeButtonHeight)
                        roomTypeOffsetX += roomTypeButton.frame.maxX
                    } else {
                        roomTypeOffsetX += roomTypeButton.frame.maxX + 20
                        if(roomTypeOffsetX > self.roomTypeView.frame.width) {
                            count += 1
                            roomTypeButtonX = 0
                        } else {
                            roomTypeButtonX = roomTypeOffsetX - roomTypeButtonWidth
                        }
                    }
                    
                    roomTypeButtonY = CGFloat(count)*(roomTypeButtonHeight+10)+30
                    roomTypeButton.frame = CGRect(x: roomTypeButtonX, y: roomTypeButtonY, width: roomTypeButtonWidth, height: roomTypeButtonHeight)
                    roomTypeViewRealHeight = roomTypeButton.frame.maxY
                    self.roomTypeView.addSubview(roomTypeButton)

                }
                
                self.roomTypeViewHeight.constant = roomTypeViewRealHeight

                
                
            }
        }
        
        
    }
    
    /// 下一个图片
    func nextImage() {
        if pageControl.currentPage == imageCount - 1 {
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage += 1
        }
        let contentOffset = CGPoint(x: scrollView.frame.width * 2, y: 0)
        scrollView.setContentOffset(contentOffset, animated: true)
    }
    
    /// 上一个图片
    func preImage() {
        if pageControl.currentPage == 0 {
            pageControl.currentPage = imageCount - 1
        } else {
            pageControl.currentPage -= 1
        }
        
        let contentOffset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(contentOffset, animated: true)
    }
    
    
    /// 重新加载图片，重新设置3个imageView
    func reloadImage() {
        let currentIndex = pageControl.currentPage
        let nextIndex = (currentIndex + 1) % 4
        let preIndex = (currentIndex + 3) % 4
        let images = self.house["images"] as? String
        let imageArr = images?.components(separatedBy: "|")
//        (scrollView.subviews[0] as! UIImageView).image = UIImage(named: (imageArr?[preIndex])!)
//        (scrollView.subviews[1] as! UIImageView).image = UIImage(named: (imageArr?[currentIndex])!)
//        (scrollView.subviews[2] as! UIImageView).image = UIImage(named: (imageArr?[nextIndex])!)
        
        let placeholderImage = UIImage(named: "WechatIMG3")!
        let url0 = URL(string:  AppDelegate.baseURLString + "/house_images/" + (imageArr?[preIndex])!)!
        let url1 = URL(string:  AppDelegate.baseURLString + "/house_images/" + (imageArr?[currentIndex])!)!
        let url2 = URL(string:  AppDelegate.baseURLString + "/house_images/" + (imageArr?[nextIndex])!)!

        (scrollView.subviews[0] as! UIImageView).af_setImage(withURL: url0, placeholderImage: placeholderImage)
        (scrollView.subviews[1] as! UIImageView).af_setImage(withURL: url1, placeholderImage: placeholderImage)
        (scrollView.subviews[2] as! UIImageView).af_setImage(withURL: url2, placeholderImage: placeholderImage)
        
    }
    
    
    func mergeRoomIds() -> String {
        
        var roomIdArr = Array<String>()

        
        let room0 = self.house["room0"]
        let room1 = self.house["room1"]
        let room2 = self.house["room2"]
        let room3 = self.house["room3"]
        let room4 = self.house["room4"]
        let room5 = self.house["room5"]
        let room6 = self.house["room6"]
        let room7 = self.house["room7"]
        let room8 = self.house["room8"]
        let room9 = self.house["room9"]
        
        
        if(!(room0 is NSNull)) {
            roomIdArr.append(room0 as! String)
        }
        
        if(!(room1 is NSNull)) {
            roomIdArr.append(room1 as! String)
        }
        
        if(!(room2 is NSNull)) {
            roomIdArr.append(room2 as! String)
        }
        
        if(!(room3 is NSNull)) {
            roomIdArr.append(room3 as! String)
        }
        
        if(!(room4 is NSNull)) {
            roomIdArr.append(room4 as! String)
        }
        
        if(!(room5 is NSNull)) {
            roomIdArr.append(room5 as! String)
        }
        
        if(!(room6 is NSNull)) {
            roomIdArr.append(room6 as! String)
        }
        
        if(!(room7 is NSNull)) {
            roomIdArr.append(room7 as! String)
        }
        
        if(!(room8 is NSNull)) {
            roomIdArr.append(room8 as! String)
        }
        
        if(!(room9 is NSNull)) {
            roomIdArr.append(room9 as! String)
        }
        
        return roomIdArr.joined(separator: "-")
    }
    
    
    func chooseRoomType(sender:UIButton?) {
        
        for view in self.roomTypeView.subviews {
            if view.isKind(of: UIButton.self) {
                let button = view as! UIButton
                button.backgroundColor = UIColor(colorLiteralRed: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
                button.setTitleColor(UIColor.black, for: .normal)
            }
        }
        
        
        sender?.backgroundColor = UIColor(colorLiteralRed: 255/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1)
        sender?.setTitleColor(UIColor(colorLiteralRed: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1), for: .normal)
        let index = (sender?.tag)! - 10000
        let selectedRoom = self.roomArray[index]
        self.roomNo.text = selectedRoom["roomNo"] as? String
        self.price.text = String(format: "￥%@/晚", (selectedRoom["price"] as! String))



    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let loginVC = segue.destination as! LoginViewController
        loginVC.delegate = self
        
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let userDefaults = UserDefaults.standard
        let memberDic = userDefaults.dictionary(forKey: "member")
        
        if (memberDic != nil) {
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            let authController = storyboard.instantiateViewController(withIdentifier: "AuthenticationController")
            authController.title = "认证"
            self.navigationController?.pushViewController(authController, animated: true)
            
            return false
        }
        
        return true
    }
    
    
    func bookHouse() {
        let userDefaults = UserDefaults.standard
        let memberDic = userDefaults.dictionary(forKey: "member")
        
        if (memberDic != nil) {
            
            let level = memberDic?["level"] as! String
            
            if Int(level)! < 3 {
                let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                let authController = storyboard.instantiateViewController(withIdentifier: "AuthenticationController")
                authController.title = "认证"
                self.navigationController?.pushViewController(authController, animated: true)
            }
                        
        }
    }
    
}



extension HouseDetailController: UIScrollViewDelegate {
    
    /// 开始滑动的时候，停止timer，设置为niltimer才会销毁
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

    }
    
    /// 当停止滚动的时候重新设置三个ImageView的内容，然后悄悄滴显示中间那个imageView
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        reloadImage()
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: false)
    }
    
    /// 停止拖拽，开始timer, 并且判断是显示上一个图片还是下一个图片
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.x < scrollView.frame.width {
            preImage()
        } else {
            nextImage()
        }
    }
    
    
}
