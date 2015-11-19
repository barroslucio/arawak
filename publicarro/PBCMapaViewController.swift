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
    var geoCoder: CLGeocoder! // a classe CLGecoder fornece servicos de uma conversao de uma coordenada

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var local: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        geoCoder = CLGeocoder()
    
        self.mapView.delegate = self
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print(error)
    }
  
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        //Define as coordenadas no centro do mapa
        geoCode(location)
    }
    
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        mapView.centerCoordinate = (userLocation.location?.coordinate)!
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location: CLLocation = locations.first!
        self.mapView.centerCoordinate = location.coordinate // defini as coordenada no centro

        let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
        self.mapView.setRegion(reg, animated: true)
        
        geoCode(location)
    }
    
    func geoCode(location: CLLocation!)
    {
        // location contém os dados das coordenadas
       
        geoCoder.cancelGeocode() //cancela uma solicitacao de geocodificacao pendente
        
       // envia os dados de localização especificados para o servidor de geocodificação
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(data,error) -> Void in
        
            guard let placemarks = data as [CLPlacemark]! else
            {
                return
            }
            
            // CLPlacemark armazena todos os dados da localização
            let loc: CLPlacemark = placemarks.last!
            
            PBCCadastroMotoristaTableViewController.detalhesLocation = loc as CLPlacemark
            
            let addressDict: [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
            // addresssDictionary fornece o endereco completo
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            

            let address = addrList.joinWithSeparator(" ,")
            print("\n\nAdress:\(address)")
            self.local.text = address
        })
    }
    
    
    @IBAction func estouAqui(sender: AnyObject)
    {
        PBCCadastroMotoristaTableViewController.printLocationMotorista(PBCCadastroMotoristaTableViewController.detalhesLocation!)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
 
    @IBAction func current(sender: AnyObject)
    {
        mapView.showsUserLocation = true
        
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),
            {
                self.mapView.showsUserLocation = false
            })
    }

}
