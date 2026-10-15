//
//  LocationManager.swift
//  Entedeal
//
//  Created by ramesh on 04/07/19.
//  Copyright © 2019 EmbitelTechnologies. All rights reserved.


import Foundation
import CoreLocation
import UIKit

enum LocationHelperStatus {
    case notAuthorized
    case denied
    case authorized
    case restricted
}

class LocationManager: NSObject,CLLocationManagerDelegate {
    fileprivate var locationManager = CLLocationManager()
    fileprivate var currentLocation : CLPlacemark?
    internal var permissionHandler: (() ->Void)? = nil
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //        stopLocationService()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
        case .notDetermined:
            break
            
        case .denied:
            if permissionHandler != nil {
                permissionHandler!()
            }
            break
            
        case .authorizedWhenInUse:
            if permissionHandler != nil {
                permissionHandler!()
            }
            break
            
        case .authorizedAlways:
            if permissionHandler != nil {
                permissionHandler!()
            }
            break
        case .restricted:
            break
        
        }
    }
    
    func getCurrentLocation() -> CLLocation {
        if let location = self.locationManager.location {
            return location
        }
        return CLLocation()//updated by ravindra
    }
    
    func permissionEnabled() ->Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        } else {
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        stopLocationService()
        //        if locationManager.location != nil {
        //            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
        //                if (error != nil || placemarks == nil) {
        //                    self.result!(nil, Constants.locationConnectivityAlertMessage)
        //                    return
        //                }
        //                if placemarks!.count > 0 {
        //                    let pm = placemarks![0]
        //                    self.displayLocationInfo(placemark: pm)
        //                }else {
        //                    self.result!(nil, "GPS is not able to get address from your location.")
        //                }
        //            })
        //        }else {
        //            self.result!(nil, "Please enable location from settings")
        //        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        stopLocationService()
        //        guard let address = Address().loadAddressFromGeoLocation(geoLocation: placemark) else {
        //            self.result!(nil, "GPS is not able to get address from your location.")
        //            return
        //        }
        //
        //        self.result!(address,nil)
        //        UserDefaults.standard.set(placemark.postalCode, forKey: Constants.kPincode)
    }
    
    func stopLocationService() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    //    func getPincodeFromLocationManager(completion: @escaping (Address?, String?) ->()) {
    //        self.result = completion
    //        locationManager.delegate = self
    //        locationManager.startUpdatingLocation()
    //    }
    
    func getPermissionStatus(completion: @escaping () ->()) {
        self.permissionHandler = completion
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let authstate = CLLocationManager.authorizationStatus()
        if(authstate == CLAuthorizationStatus.notDetermined) {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func isLocationServiceAvailable() ->Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func isLocationDetermined() ->Bool {
        let authstate = CLLocationManager.authorizationStatus()
        if authstate == CLAuthorizationStatus.notDetermined {
            return false
        }else {
            return true
        }
    }
    
    func isLocationDenied() ->Bool {
        let authstate = CLLocationManager.authorizationStatus()
        if authstate == CLAuthorizationStatus.denied {
            return true
        }else {
            return false
        }
    }
    

    func showUserLocationSettingsAlert(viewController: UIViewController, completionHandler: @escaping (Int) ->()) {
        let alertController = UIAlertController(
            title: "SocialDistance",
            message: "Location is Disabled",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            completionHandler(0)
        }
        alertController.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl)  {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                }
                else  {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
        alertController.addAction(openAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

