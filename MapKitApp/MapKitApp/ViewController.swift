//
//  ViewController.swift
//  MapKitApp
//
//  Created by Sina Taherkhani on 6/24/1400 AP.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    var mapview=MKMapView()
    let locationManager=CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapview.frame=CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(mapview)
        self.mapview.delegate = self
        self.gotoLocation()
        self.addpin()
        self.gotoUserLocation()
    }
    func drawlinebetween(){
        let source_latitute:Double! = 40.797963
        let source_longitute:Double! = -73.412824
        let destination_latitute:Double! = 40.805235
        let destination_longitute:Double! = -73.450046
        
       // 40.758808246389584, -73.98477752607748
        
        let sourceLocation=CLLocationCoordinate2D(latitude: source_latitute, longitude: source_longitute)
        let destLoc=CLLocationCoordinate2D(latitude: destination_latitute, longitude: destination_longitute)
        let SP=MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let DP=MKPlacemark(coordinate: destLoc, addressDictionary: nil)
        let smi=MKMapItem(placemark: SP)
        let dmi=MKMapItem(placemark: DP)
        let SourceAnnotation=MKPointAnnotation()
        SourceAnnotation.title="times square"
        if  let location = SP.location{
            SourceAnnotation.coordinate=location.coordinate
        }
        let destAnnotation=MKPointAnnotation()
        destAnnotation.title="lp"
        if  let location = DP.location{
            destAnnotation.coordinate=location.coordinate
        }
        self.mapview.showAnnotations([SourceAnnotation,destAnnotation], animated: true)
        let dirReq=MKDirections.Request()
        dirReq.source=smi
        dirReq.destination=dmi
        dirReq.transportType = .automobile
        let directions=MKDirections(request: dirReq)
        directions.calculate{(response,error) -> Void in
            guard let response = response else{
                if let error = error{
                    print("error=\(error)")
                }
                return
            }
            let rout = response.routes[0]
            self.mapview.addOverlay((rout.polyline),level:MKOverlayLevel.aboveLabels)
            let rect = rout.polyline.boundingMapRect
            self.mapview.setRegion(MKCoordinateRegion(rect), animated: true)
            self.mapview.setVisibleMapRect(rect, animated: true)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if let location=locationManager.location?.coordinate{
//            let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
//            let region = MKCoordinateRegion.init(center: location, span: span)
//            self.getdirection(loc1: CLLocationCoordinate2D(latitude: 43.748441, longitude: -73.985564), loc2: CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564))
//        }
        drawlinebetween()
    }
    func getdirection(loc1:CLLocationCoordinate2D,loc2:CLLocationCoordinate2D) {
        let source=MKMapItem(placemark: MKPlacemark(coordinate: loc1))
        source.name="firt"
        let dest=MKMapItem(placemark: MKPlacemark(coordinate: loc2))
        dest.name="last"
        MKMapItem.openMaps(with: [source,dest], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
    }
    func gotoLocation() {
        let cordinate = CLLocationCoordinate2D(latitude: 25.1972, longitude: 55.2744)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: cordinate, span: span)
        self.mapview.setRegion(region, animated: true)
    }
    func addpin(){
        let pin=MKPointAnnotation()
        pin.coordinate=CLLocationCoordinate2D(latitude: 25.1972, longitude: 55.2744)
        pin.title="arab"
        pin.subtitle="looooooooool"
        self.mapview.addAnnotation(pin)
    }
    func gotoUserLocation(){
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation
            mapview.showsUserLocation=true
            self.locationManager.delegate=self
            
            if let location=locationManager.location?.coordinate{
                let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                let region = MKCoordinateRegion.init(center: location, span: span)
                self.mapview.setRegion(region, animated: true)
                
            }
        }
    }
}

extension ViewController{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.fillColor = UIColor.red
        renderer.lineWidth = CGFloat(4.0)
        if #available(iOS 14.0, *) {
            renderer.strokeStart=CGFloat(Float(5))
            renderer.strokeEnd=CGFloat(Float(5))
        } else {
            print("l")
        }
        renderer.strokeColor = UIColor.blue
        return renderer
    }
}
