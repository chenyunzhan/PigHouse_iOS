//
//  ViewController.swift
//  PigHouse
//
//  Created by zhan on 2017/5/9.
//  Copyright © 2017年 zhan. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController, MAMapViewDelegate,AMapNaviWalkManagerDelegate {

    var mapView: MAMapView!
    var annotations: Array<MAPointAnnotation>!
    var houseArray: Array<Dictionary<String, Any>>!
    var selectedHouse: Dictionary<String, Any>!
    var walkManager: AMapNaviWalkManager!
    
    var startPoint: AMapNaviPoint!
    var endPoint: AMapNaviPoint!
    
    @IBOutlet weak var houseInfoView: UIView!
    
    @IBOutlet weak var useHouseButton: UIButton!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var structure: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AMapServices.shared().enableHTTPS = true
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self;
        mapView.userTrackingMode = MAUserTrackingMode.follow
        self.view.addSubview(mapView)
        
        
        walkManager = AMapNaviWalkManager()
        walkManager.delegate = self
        
        initAnnotations()
        
        
//        self.view.bringSubview(toFront: self.houseInfoView)
//        self.view.bringSubview(toFront: self.useHouseButton)

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
        self.selectedHouse = house
        self.name.text = house["name"] as? String
        self.address.text = house["address"] as? String
        self.structure.text = house["structure"] as? String
        self.price.text = String(format: "%@元", (house["price"] as! String))
        
        
        self.endPoint = AMapNaviPoint.location(withLatitude: CGFloat(view.annotation.coordinate.latitude), longitude: CGFloat(view.annotation.coordinate.longitude))
        
        
        //为了方便展示步行路径规划，选择了固定的起终点
        walkManager.calculateWalkRoute(withStart: [self.startPoint], end: [self.endPoint])


    }
    
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        
        for view in views {
            let annoationview = view as! MAAnnotationView
            annoationview.canShowCallout = false;
        }
        
    }
    
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        
        self.startPoint = AMapNaviPoint.location(withLatitude: CGFloat(userLocation.coordinate.latitude), longitude: CGFloat(userLocation.coordinate.longitude))
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
        
        
        self.distance.text = String(format: "%d米", aRoute.routeLength)
        
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        
        if overlay is SelectableOverlay {
            let selectableOverlay = overlay as! SelectableOverlay
            
            let polylineRenderer = MAPolylineRenderer(overlay: selectableOverlay.overlay)
            polylineRenderer?.lineWidth = 8.0
            polylineRenderer?.strokeColor = selectableOverlay.selected ? selectableOverlay.selectedColor : selectableOverlay.reguarColor
            
            return polylineRenderer
        }
        return nil
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let houseDetail = segue.destination as! HouseDetailController
        houseDetail.house = self.selectedHouse

    }
    
}

