//
//  PBCMapaViewController.swift
//  publiCarro
//
//  Created by Eduarda Pinheiro on 12/11/15.
//  Copyright © 2015 tambatech. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class PBCMapaViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{

    var locationManager : CLLocationManager!
    var endereco: String!
    var geoCoder: CLGeocoder! // a classe CLGecoder fornece servicos de uma conversao de uma coordenada

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var local: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        geoCoder = CLGeocoder()
    
        self.mapView.delegate = self
        
        local.layer.masksToBounds = true
        local.layer.cornerRadius = 8.0
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        //defini as coordenadas no centro do mapa
        
        geoCode(location)
    }
    
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        mapView.centerCoordinate = (userLocation.location?.coordinate)!
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location: CLLocation = locations.first!
        self.mapView.centerCoordinate = location.coordinate // defini as coordenada no centro

        let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
        self.mapView.setRegion(reg, animated: true)
        
    
        geoCode(location)
        
        
    }
    
    
    func geoCode(location: CLLocation!) {
        
        geoCoder.cancelGeocode() //cancela uma solicitacao de geocodificacao pendente
        
       // location contém os dados das coordenadas
       // envia os dados de localização especificados para o servidor de geocodificação
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(data,error) -> Void in
        
        guard let placemarks = data as [CLPlacemark]! else {
            return
            }
            
            // CLPlacemark armazena dados de uma determina Latitude e longitude como cidade, estado ,país
            let loc: CLPlacemark = placemarks[0]
            
            let addressDict: [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
            // addresssDictionary fornece o endereco completo
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            
            
           let address = addrList.joinWithSeparator(" ,")
           print(address)
           self.local.text = address
          self.endereco = address
        })
        
      
        
        
    }
    
    
    
    @IBAction func estouAqui(sender: AnyObject) {
        
        print("LOCAL DO MOTORISTA: \(endereco)")
    }
    
    

    
    
 /*   func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        print("Localização \(newLocation.coordinate.latitude),\(newLocation.coordinate.longitude)")
        
    
        myPosition = newLocation.coordinate
       // locationManager.stopUpdatingLocation()
        
       var span = MKCoordinateSpanMake(0.03,0.03)

       var region = MKCoordinateRegion(center:newLocation.coordinate,span:span)
        mapView.setRegion(region,animated:true)
        
       // locationManager.stopUpdatingLocation()
        
     
        
    }
  
    
    
    func addPin(gestureRecognizer:UIGestureRecognizer){
        
       
        let touchPoint = gestureRecognizer.locationInView(mapView)
        let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        var annotation = MKPointAnnotation()
        
        annotation.coordinate = newCoordinates
        
        
        annotation.title = "Aqui"
        annotation.subtitle = "Estou aqui"
        
         self.mapView.removeAnnotations(mapView.annotations)
 
        self.mapView.addAnnotation(annotation)
      
        
    
}
    
    
   
    
  

     /* @IBAction func addPin(sender: UILongPressGestureRecognizer) {

        let location = sender.locationInView(self.mapView)

        let locCoord = self.mapView.convertPoint(location, toCoordinateFromView: self.mapView)

        var annotation = MKPointAnnotation()

        annotation.coordinate = locCoord
        
        
        annotation.title = "Aqui"
        annotation.subtitle = "Estou aqui"
        
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotation(annotation)
        
        
        
    }
*/

*/
    
    
    
  



}
