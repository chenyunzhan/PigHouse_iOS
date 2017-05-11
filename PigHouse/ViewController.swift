//
//  ViewController.swift
//  PigHouse
//
//  Created by zhan on 2017/5/9.
//  Copyright © 2017年 zhan. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate,AMapNaviWalkManagerDelegate {

    var mapView: MAMapView!
    var annotations: Array<MAPointAnnotation>!
    var houseArray: Array<Dictionary<String, Any>>!
    var search: AMapSearchAPI!
    var walkManager: AMapNaviWalkManager!
    
    var startAnnotation: MAPointAnnotation?
    var destinationAnnotation: MAPointAnnotation?
    
    @IBOutlet weak var houseInfoView: UIView!
    
    @IBOutlet weak var useHouseButton: UIButton!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var structure: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AMapServices.shared().enableHTTPS = true
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self;
        mapView.userTrackingMode = MAUserTrackingMode.follow
        self.view.addSubview(mapView)
        
        search = AMapSearchAPI()
        search.delegate = self
        
        walkManager = AMapNaviWalkManager()
        walkManager.delegate = self
        
        initAnnotations()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    

    
    func initAnnotations() {
        
        annotations = Array()

        
        Alamofire.request(AppDelegate.baseURLString+"/house/all").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                
                let houseArray = JSON as! Array<Dictionary<String, Any>>
                self.houseArray = houseArray
                
                for i in 0 ..< houseArray.count{
                    let lat = houseArray[i]["latitude"] as! String
                    let long = houseArray[i]["longitude"] as! String
                    
                    let coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
                    let anno = MAPointAnnotation()
                    anno.coordinate = coordinate
                    anno.title = String(i)
                    
                    
                    self.annotations.append(anno)
                }

                
                self.mapView.addAnnotations(self.annotations)
                self.mapView.showAnnotations(self.annotations, edgePadding: UIEdgeInsetsMake(20, 20, 20, 20), animated: true)
                self.mapView.selectAnnotation(self.annotations.first, animated: true)
                
                
            }
        }
        
        
        
        
        
        
//        let coordinates: [CLLocationCoordinate2D] = [
//            CLLocationCoordinate2D(latitude: 34.242546, longitude: 108.876651),
//            CLLocationCoordinate2D(latitude: 34.193909, longitude: 108.943202)]
//        
//        for (idx, coor) in coordinates.enumerated() {
//            let anno = MAPointAnnotation()
//            anno.coordinate = coor
//            anno.title = String(idx)
//            
//            
//            annotations.append(anno)
//        }
        
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
            annotationView?.tag = 10000 + idx!
            return annotationView!
        }
        
        return nil
    }
    
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        
        if(view.annotation.isKind(of: MAUserLocation.self)){
            return
        }
        

        self.view.bringSubview(toFront: self.houseInfoView)
        self.view.bringSubview(toFront: self.useHouseButton)
        let house = self.houseArray[view.tag-10000]
        self.name.text = house["name"] as? String
        self.address.text = house["adress"] as? String
        self.structure.text = house["structure"] as? String
        self.price.text = house["attribute0"] as? String
        
        
        
        self.destinationAnnotation = view.annotation as? MAPointAnnotation
        
        self.searchRoutePlanningWalk()


    }
    
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        
        let annoationview = views.first as! MAAnnotationView
        annoationview.canShowCallout = false;

        
    }
    
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        let userAnnotation = MAPointAnnotation()
        userAnnotation.coordinate = userLocation.coordinate
        self.startAnnotation = userAnnotation
    }
    
    
    func searchRoutePlanningWalk() -> Void {
        let navi = AMapWalkingRouteSearchRequest()
        navi.origin = AMapGeoPoint.location(withLatitude: CGFloat(self.startAnnotation!.coordinate.latitude), longitude: CGFloat(self.startAnnotation!.coordinate.longitude))
        navi.destination = AMapGeoPoint.location(withLatitude: CGFloat(self.destinationAnnotation!.coordinate.latitude), longitude: CGFloat(self.destinationAnnotation!.coordinate.longitude))
        
        search.aMapWalkingRouteSearch(navi)

    }
    
    
    func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
        if response.count > 0 {
            //解析response获取路径信息
            self.presentCurrentCourse()
        }
    }
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("Error:\(error)")
    }
    
    
    
    func presentCurrentCourse() -> Void {
        
//        let startPoint = AMapNaviPoint.location(withLatitude: 39.993135, longitude: 116.474175)!
        let startPoint = AMapNaviPoint.location(withLatitude: CGFloat((self.startAnnotation?.coordinate.latitude)!), longitude: CGFloat((self.startAnnotation?.coordinate.longitude)!))
        let endPoint = AMapNaviPoint.location(withLatitude: CGFloat((self.destinationAnnotation?.coordinate.latitude)!), longitude: CGFloat((self.destinationAnnotation?.coordinate.longitude)!))
        walkManager.calculateWalkRoute(withStart: [startPoint!], end: [endPoint!])

        
    }
    
    
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        NSLog("CalculateRouteSuccess")
        
        
        
        guard let aRoute = walkManager.naviRoute else {
            return
        }
        
        mapView.removeOverlays(mapView.overlays)
//        routeIndicatorInfoArray.removeAll()
        
        //将路径显示到地图上
        var coords = [CLLocationCoordinate2D]()
        for coordinate in aRoute.routeCoordinates {
            coords.append(CLLocationCoordinate2D.init(latitude: Double(coordinate.latitude), longitude: Double(coordinate.longitude)))
        }
        
        //添加路径Polyline
        let polyline = MAPolyline(coordinates: &coords, count: UInt(aRoute.routeCoordinates.count))!
        let selectablePolyline = SelectableOverlay(aOverlay: polyline)
        
        mapView.add(selectablePolyline)
        
        
        //更新CollectonView的信息
//        let subtitle = String(format: "长度:%d米 | 预估时间:%d秒 | 分段数:%d", aRoute.routeLength, aRoute.routeTime, aRoute.routeSegments.count)
//        let info = RouteCollectionViewInfo(routeID: 0, title: "路径信息:", subTitle: subtitle)
//        
//        routeIndicatorInfoArray.append(info)
//        
//        mapView.showAnnotations(mapView.annotations, animated: false)
//        routeIndicatorView.reloadData()
        
//        for point in pointArray! {
//            
//        }
        
        //显示路径或开启导航
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

