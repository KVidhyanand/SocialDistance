//
//  ViewController.swift
//  SafetyDemo
//

import UIKit
import CoreLocation
import AVFoundation


extension Double {
    var rounded:String {
        return String(format: "%.7f", self)
    }
}

/*
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}*/

class ViewController: UIViewController, CLLocationManagerDelegate,HelperProtocol,UITableViewDelegate, UITableViewDataSource {
    
    private var locationManager =  CLLocationManager()
    var currentLocation: CLLocation!
    var currrentCity:String?
    
    var player: AVAudioPlayer?
    
    @IBOutlet var locationsTableView: UITableView!
    
    @IBOutlet var logoImageView: UIImageView!
    
    @IBOutlet var logoHeightCons: NSLayoutConstraint!
    
    @IBOutlet var getLocationBtn: UIButton!
    
    var currLatitude: Double!
    
    var currLongitude: Double!
    
    var destLatitude: Double!
    
    var destLongitude: Double!
    
    var locationsArr: NSArray!
    
    var getLoctimer: Timer!
    
    @IBOutlet var currLatitudeLbl: UILabel!
    
    @IBOutlet var currLongitudeLbl: UILabel!
    
    @IBOutlet var usernameLbl: UILabel!
    
    @IBOutlet var addressLbl: UILabel!
    
    var userIDStr: String!
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier! = UIBackgroundTaskIdentifier(rawValue: 1)
    
    var serviceRepository: ServiceRepository? = ServiceRepository()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.getLocationBtn.layer.cornerRadius = 10
        self.getLocationBtn.layer.masksToBounds = true
        
        self.getLoctimer = Timer()
        
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.startUpdatingLocation()
        }
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
       
        self.serviceRepository = ServiceRepository()
        self.serviceRepository?.delegate=self
        
        locationsArr = []
        
        self.userIDStr = "1"
        
        //let userDefaults = UserDefaults.standard
        
        //let userDict: NSDictionary = userDefaults.object(forKey: "LoginDict") as! NSDictionary
        
        let userDict: NSDictionary = self.getValueFromDefaults(key: "LoginDict") as? NSDictionary ?? NSDictionary()
        
        if userDict.allKeys.count > 0 {
            
            self.usernameLbl.text = (userDict.object(forKey: "UserName") as! String)
            
            self.userIDStr  = String(userDict.object(forKey: "UserId") as! Int)
            
            print(self.userIDStr ?? "1")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden=false
        self.title="Social Distance"
        
        self.serviceRepository = ServiceRepository()
        self.serviceRepository?.delegate=self
        
        SVProgressHUD.show()
        
        self.getCurrentLocation()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        
      super.viewWillDisappear(animated);

        if (self.isMovingFromParent) {
            
            /*
            let userDefaults = UserDefaults.standard
            let dictionary = NSDictionary()
            userDefaults.setValue(dictionary, forKey: "LoginDict")
            userDefaults.setValue("0", forKey: "AutoLogin")*/
            
            let dictionary = NSDictionary()
            let autoLoginStr = "" as NSString
            
            self.setValueToDefaults(key: "LoginDict", value: dictionary)
            self.setValueToDefaults(key: "AutoLogin", value: autoLoginStr)
    
           SVProgressHUD.dismiss()
           
           self.getLoctimer.invalidate()
           self.getLoctimer = nil

           self.stopSound()
           self.player = nil
           self.locationManager.stopUpdatingLocation()
           self.locationManager.delegate = nil
            self.serviceRepository?.delegate = nil
            self.serviceRepository = nil
        // Do your stuff here
      }
    }

        
    // custom methods
    
    public func getCurrentLocation(){
        self.currentLocation = locationManager.location
        let geoCoder = CLGeocoder()
        if let loc = self.currentLocation{
            geoCoder.reverseGeocodeLocation(loc) { placemarks, error in
                
                SVProgressHUD.dismiss()

                if let e = error {
                    print("error\(e)")
                    
                } else {
                    
                    let placeArray = placemarks
                    
                    var placeMark: CLPlacemark!
                    
                    placeMark = placeArray?[0]
                    
                    guard let address = placeMark.addressDictionary  else {
                        return
                    }
                    
                    self.currrentCity = address["City"] as? String
                    
                    /*
                    self.currLatitude = self.currentLocation.coordinate.latitude.rounded(toPlaces: 3)
                    self.currLongitude = self.currentLocation.coordinate.longitude.rounded(toPlaces: 3) */
                    
                    self.currLatitude = self.currentLocation.coordinate.latitude as Double
                    self.currLongitude = self.currentLocation.coordinate.longitude as Double
                    
                    self.currLatitudeLbl.text! = self.currLatitude.rounded
                    self.currLongitudeLbl.text! = self.currLongitude.rounded
                    
                    /*
                    self.currLatitudeLbl.text = String(self.currentLocation.coordinate.latitude)
                    self.currLongitudeLbl.text = String(self.currentLocation.coordinate.longitude)*/
                    
                    /*
                    self.currLatitudeLbl.text = String(self.currentLocation.coordinate.latitude.rounded(toPlaces: 8))
                    self.currLongitudeLbl.text = String(self.currentLocation.coordinate.longitude.rounded(toPlaces: 8))*/
                    
                    self.addressLbl.text = self.currrentCity
                    
                    self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                        UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
                    })
                    
                    // timeInterval: 10
                    
                    self.getLoctimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.postLocationDetails), userInfo: nil, repeats: true)
                    
                    self.getLoctimer.fire()
                    
                    //self.postLocationDetails()
                    
                }
                
            }
        }
    }
    
    func distanceBetweenLocations(latitude: Double, longitude:Double) -> Double {
        
        /*
        let coordinate0 = CLLocation(latitude: self.currLatitude.rounded(toPlaces: 3), longitude: self.currLongitude.rounded(toPlaces: 3))
        let coordinate1 = CLLocation(latitude: latitude.rounded(toPlaces: 3), longitude: longitude.rounded(toPlaces: 3))*/
        
        /*
        let coordinate0 = CLLocation(latitude: self.currLatitude.rounded(toPlaces: 8), longitude: self.currLongitude.rounded(toPlaces: 8))
        let coordinate1 = CLLocation(latitude: latitude.rounded(toPlaces: 8), longitude: longitude.rounded(toPlaces: 8))*/
        
        /*
        let coordinate0 = CLLocation(latitude: self.currLatitude, longitude: self.currLongitude)
        let coordinate1 = CLLocation(latitude: latitude, longitude: longitude)*/
        
        let myLatitude: String = self.currLatitude.rounded
        let myLongitude: String = self.currLongitude.rounded
        
        let otherLatitude: String = latitude.rounded
        let otherLongitude: String = longitude.rounded

        let coordinate0 = CLLocation(latitude: Double(myLatitude)!, longitude: Double(myLongitude)!)
        let coordinate1 = CLLocation(latitude: Double(otherLatitude)!, longitude: Double(otherLongitude)!)
        
        self.destLatitude = latitude
        self.destLongitude = longitude

        let distanceInMeters = coordinate0.distance(from: coordinate1) // result is in meters
        
        //print(distanceInMeters)
                
        let heightMeters = Measurement(value: distanceInMeters, unit: UnitLength.meters)
        
        //print(heightMeters)
        
        let heightFeet = heightMeters.converted(to: UnitLength.feet)
        
        print("@@@@ Location Method @@@@@")
        //print(heightMeters)
        print(heightFeet)
        
        return heightFeet.value
        
    }
    @objc func getLocations() {
        
        //SVProgressHUD.show()
                
        let baseUrl = AppDelegate.baseURL()
        
        let baseURLStr = (baseUrl as String) + "locations"
        
        let urlStr = baseURLStr as String
        
        print(urlStr)
        
        self.serviceRepository?.getDetailsFromURL(urlString: urlStr, serviceTypeStr: "GetLocations")
    }

    // MARK: -- tableview delegate
       
       func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
           
           let view:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 10))
           view.backgroundColor = .clear
           
           return view
       }
       
       func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationsArr.count;
       }
       
       func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
           return 5.0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cellIdentifier = "Cell"
           
           //Accessing Custom Cell with xib
           var cell : LocationsCell!  = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LocationsCell)
           
           if cell == nil
           {
               tableView.register(UINib(nibName: "LocationsCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
               cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LocationsCell
           }
        cell.selectionStyle=UITableViewCell.SelectionStyle.none
           
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        cell.bgView.layer.cornerRadius = 10
        cell.bgView.layer.masksToBounds = true
           
        let locationDict = locationsArr[indexPath.row] as! NSDictionary
        
        cell.latitudeLbl.text = (locationDict.object(forKey: "latitude") as! String)
        cell.longitudeLbl.text = (locationDict.object(forKey: "longitude") as! String)
        cell.usernameLbl.text = (locationDict.object(forKey: "UserName") as! String)
                        
        //cell.distanceLbl.text = locationDict.object(forKey: "") as! String
        let distanceInFeet: Double = self.distanceBetweenLocations(latitude: Double(locationDict.object(forKey: "latitude") as! String)!, longitude: Double(locationDict.object(forKey: "longitude") as! String)!)
        var distance: Int = Int(distanceInFeet)
        
        // June 17th, 2020 Vidya
        
        /*
        if distance >= 13 {
            distance = distance - 15
        }*/
                
        // 20  // 15
        
        /*
        if distance >= 10 {
            distance = distance - 10
        }*/
        
        
        if distance >= 9 {
            distance = distance - 15
        }
        
        if distance < 0 {
            distance = 0
        }
        
        if distance <= 6 {
            cell.zoneLbl.text = "RED"
            //cell.backgroundColor = UIColor.red
            cell.bgView.backgroundColor = UIColor.red
        }else {
            cell.zoneLbl.text = "GREEN"
            //cell.backgroundColor = UIColor.green
            cell.bgView.backgroundColor = UIColor(red: 0.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
        
        /*
        if distance - 10 < 0 {
            distance = 0
        }
        cell.distanceLbl.text = "\(distance - 10)" + "  " + "FEET"*/
        
          cell.distanceLbl.text = "\(distance)" + "  " + "FEET"
        
           return cell
        
        /*
        if distance+10 > 0{
                    if distance-10 <= 7 {
                cell.zoneLbl.text = "RED"
                cell.backgroundColor = UIColor.red
            }else {
                cell.zoneLbl.text = "GREEN"
                cell.backgroundColor = UIColor.green
            }
            cell.distanceLbl.text = "\(distance-10)" + "  " + "FEET"
               return cell

        }else {
            
            if distance <= 7 {
                cell.zoneLbl.text = "RED"
                cell.backgroundColor = UIColor.red
            }else {
                cell.zoneLbl.text = "GREEN"
                cell.backgroundColor = UIColor.green
            }
            cell.distanceLbl.text = "\(distance)" + "  " + "FEET"
               return cell

        }*/
       }

       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
       {
        return 165
       }
           
    func successResponseWithAnyType(responseType: Any, withServiceType: String) {
           //print(responseType)
           
           SVProgressHUD.dismiss()
           
           let responseDict: NSDictionary = responseType as! NSDictionary
        
        if withServiceType == "GetLocations" {
            
            let locArr = responseDict.object(forKey: "Data") as! NSArray
            
            let predicate = NSPredicate.init(format: "UserId != %d", Int(self.userIDStr)!)
            
            self.locationsArr = locArr.filtered(using: predicate) as NSArray
            
            //self.locationsArr = responseDict.object(forKey: "Data") as? NSArray
            
            print(self.locationsArr as NSArray)
            
            self.checkForSafety()
            
            locationsTableView.reloadData()
            
        } else {
            
            /*
            backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
            })
            
            let getLoctimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getLocations), userInfo: nil, repeats: true)
            
            getLoctimer.fire()*/

            self.getLocations()

        }
           
           
           
        
       }
       
       func failedResponseWithAnyType(responseType: Any, withServiceType: String) {
        
           print(responseType)
           
           SVProgressHUD.dismiss()
           
        /*
           let alertCont: UIAlertController = UIAlertController.init(title: "SafetyDemo", message: "Unable to Connect to Server.",preferredStyle:.alert)
           //Create and an option action
           let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
               //Do some other stuff
           }
           alertCont.addAction(nextAction)
           self.present(alertCont, animated: true, completion: nil)*/
    }
    
    func setValueToDefaults(key:String, value:AnyObject){
        self.removeKeyValueFromDefaults(Key:key)
        UserDefaults.standard.set(value, forKey: key)

    }

    func getValueFromDefaults(key:String) ->AnyObject?{

        if((UserDefaults.standard.value(forKey: key)) != nil){

            let value:AnyObject = UserDefaults.standard.value(forKey: key)! as AnyObject

            return value
        }else{

            return nil
        }

    }

    func removeKeyValueFromDefaults(Key:String){

        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Key)
        defaults.synchronize()

    }
    
    @objc func postLocationDetails() {
        
        let userDict: NSDictionary = self.getValueFromDefaults(key: "LoginDict") as? NSDictionary ?? NSDictionary()
        
        if userDict.allKeys.count == 0 {
            
            self.getLocations()
            
            return
        }
        
        /*
        let userDefaults = UserDefaults.standard
        
        let userDict: NSDictionary = userDefaults.object(forKey: "LoginDict") as! NSDictionary
        
        if userDict.allKeys.count == 0 {
            
            return
        }*/

        //SVProgressHUD.show()
        
        /*
         
         
         savelocation
         {
         "latitude": "********",
         "longitude": "**********",
         "UserId":*
         }
         
         */
        
        /*
        let myLatitude = self.currLatitude.rounded(toPlaces: 8)
        let myLongitude = self.currLongitude.rounded(toPlaces: 8)*/
        
        let myLatitude: String = self.currLatitude.rounded
        let myLongitude: String = self.currLongitude.rounded
                
        let locationDict: Dictionary<String, Any>
                
        //locationDict = ["latitude":String(self.currLatitude),"longitude": String(self.currLongitude),"UserId": self.userIDStr as String]
        
        locationDict = ["latitude":String(myLatitude),"longitude": String(myLongitude),"UserId": self.userIDStr as String]
        
        let baseURL = AppDelegate.baseURL() + "savelocation"
        
        print("SaveLocation URL:" + baseURL)
        print(locationDict)
        
        self.serviceRepository?.postDetailsWithDictToURL(dict: locationDict as NSDictionary, urlString: baseURL as NSString, serviceTypeStr: "PostLocations")
    }
    
    @IBAction func getLocation(Sender: Any) {
        
        SVProgressHUD.show()
        
        self.getCurrentLocation()
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "fire_truck_alarm", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }
            player.numberOfLoops = 0 // loop count, set -1 for infinite
            player.volume = 1
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        
        player?.stop()
        
    }
    
    func checkForSafety() {
        
        var isUserWithinRadius: Bool = false
        
        for object in self.locationsArr as NSArray {
            
            let locationDict = object as! NSDictionary
            
            let distanceInFeet: Double = self.distanceBetweenLocations(latitude: Double(locationDict.object(forKey: "latitude") as! String)!, longitude: Double(locationDict.object(forKey: "longitude") as! String)!)
            var distance:
                Int = Int(distanceInFeet)
            
            // June 17th, 2020 Vidya
            
            /*
            if distance >= 13 {
                distance = distance - 15
            }*/
            
            // 20 // 15
            
            /*
            if distance >= 10 {
                distance = distance - 10
            }*/
            
            // 15
            
            
            if distance >= 9 {
                distance = distance - 15
            }
            
            if distance < 0 {
                distance = 0
            }
            
            if distance <= 6 {
                isUserWithinRadius = true
                break
            }else {
                isUserWithinRadius = false
            }
        }
        
        let userDict: NSDictionary = self.getValueFromDefaults(key: "LoginDict") as? NSDictionary ?? NSDictionary()
        
        if userDict.allKeys.count == 0 {
                        
            return
        }

        if isUserWithinRadius == true {
            self.playSound()
        }else {
            self.stopSound()
        }
    }
    
    /*
    func getCurrentLocation() -> CLLocation {
        if let location = self.locationManager.location {
            return location
        }
        return CLLocation()//updated by ravindra
    }*/
    
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
        //stopLocationService()
                if locationManager.location != nil {
                    
                    print(manager.location?.coordinate as Any)
                    
                    self.getCurrentLocation()
                    
                    /*
                    CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
                        if (error != nil || placemarks == nil) {
                            //self.result!(nil, Constants.locationConnectivityAlertMessage)
                            return
                        }
                        if placemarks!.count > 0 {
                            let pm = placemarks![0]
                            self.displayLocationInfo(placemark: pm)
                        }else {
                            //self.result!(nil, "GPS is not able to get address from your location.")
                        }
                    })*/
                    
                }else {
                    //self.result!(nil, "Please enable location from settings")
                }
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


}

