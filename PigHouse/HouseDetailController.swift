//
//  HouseDetailController.swift
//  PigHouse
//
//  Created by zhan on 2017/5/12.
//  Copyright © 2017年 zhan. All rights reserved.
//


class HouseDetailController: UIViewController {
    
    
    let imageCount = 4

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        for index in 0..<3 {
            
            
            let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
            imageView.image = UIImage(named: "WechatIMG\((index+3)%4)")
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            scrollView.addSubview(imageView)
            scrollView.delegate = self
            scrollView.contentSize = CGSize(width: scrollView.frame.width * 3, height: 0)
            scrollView.contentOffset = CGPoint(x: scrollView.frame.width, y: 0)
            scrollView.isPagingEnabled = true
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            
            
            pageControl.currentPage = 0
            pageControl.numberOfPages = imageCount
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
        
        (scrollView.subviews[0] as! UIImageView).image = UIImage(named: "WechatIMG\(preIndex)")
        (scrollView.subviews[1] as! UIImageView).image = UIImage(named: "WechatIMG\(currentIndex)")
        (scrollView.subviews[2] as! UIImageView).image = UIImage(named: "WechatIMG\(nextIndex)")
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
