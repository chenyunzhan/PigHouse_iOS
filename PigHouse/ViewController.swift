//
//  ViewController.swift
//  PigHouse
//
//  Created by zhan on 2017/5/9.
//  Copyright © 2017年 zhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MAMapViewDelegate  {

    var mapView: MAMapView!
    var annotations: Array<MAPointAnnotation>!

    @IBOutlet weak var houseInfoView: UIView!
    
    @IBOutlet weak var useHouseButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AMapServices.shared().enableHTTPS = true
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self;
        mapView.isShowsUserLocation = true;
        mapView.userTrackingMode = MAUserTrackingMode.follow
        self.view.addSubview(mapView)
        
        initAnnotations()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, edgePadding: UIEdgeInsetsMake(20, 20, 20, 20), animated: true)
        mapView.selectAnnotation(annotations.first, animated: true)
    }

    

    
    func initAnnotations() {
        annotations = Array()
        
        let coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 34.242546, longitude: 108.876651),
            CLLocationCoordinate2D(latitude: 34.193909, longitude: 108.943202)]
        
        for (idx, coor) in coordinates.enumerated() {
            let anno = MAPointAnnotation()
            anno.coordinate = coor
            anno.title = String(idx)
            
            
            annotations.append(anno)
        }
        
    }
    
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            
            let idx = annotations.index(of: annotation as! MAPointAnnotation)
            annotationView!.pinColor = MAPinAnnotationColor(rawValue: idx! % 3)!
            
            return annotationView!
        }
        
        return nil
    }
    
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        self.view.bringSubview(toFront: self.houseInfoView)
        self.view.bringSubview(toFront: self.useHouseButton)

    }
    
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        
        let annoationview = views.first as! MAAnnotationView
        annoationview.canShowCallout = false;

        
    }
    
    
//    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
//        if annotation is MAPointAnnotation {
//            let customReuseIndetifier: String = "customReuseIndetifier"
//            
//            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: customReuseIndetifier) as? CustomAnnotationView
//            
//            if annotationView == nil {
//                annotationView = CustomAnnotationView.init(annotation: annotation, reuseIdentifier: customReuseIndetifier)
//                
//                annotationView?.canShowCallout = false
//                annotationView?.isDraggable = true
//                annotationView?.calloutOffset = CGPoint.init(x: 0, y: -5)
//            }
//            
//            annotationView?.portrait = UIImage.init(named: "hema")
//            annotationView?.name = "河马"
//            
//            return annotationView
//        }
//        
//        return nil
//    }

}

