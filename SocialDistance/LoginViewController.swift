//
//  LoginViewController.swift
//  SafetyDemo
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, HelperProtocol {
    
    @IBOutlet var userNameTxtFld: UITextField!
    @IBOutlet var passwordTxtFld: UITextField!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var loginBgView: UIView!
    
    var serviceRepository: ServiceRepository? = ServiceRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden=false
        self.title="Social Distance"
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        self.serviceRepository = ServiceRepository()
        self.serviceRepository?.delegate=self
        
        submitBtn.layer.cornerRadius = 8
        submitBtn.layer.masksToBounds = true
        
        self.loginBgView.layer.cornerRadius = 10
        self.loginBgView.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

        //let userDefaults = UserDefaults()
        //let autoLogin: String = userDefaults.object(forKey: "AutoLogin") as? String ?? ""
        
        let autoLogin: NSString = self.getValueFromDefaults(key: "AutoLogin") as? NSString ?? "" as NSString
        
        //let userDict: NSDictionary = self.getValueFromDefaults(key: "LoginDict") as? NSDictionary ?? NSDictionary()

        if autoLogin == "1" {
                           
            
            self.userNameTxtFld.text = ""
            self.passwordTxtFld.text = ""
            
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            
            let locationsVC: ViewController = storyboard.instantiateViewController(withIdentifier: "Locations") as! ViewController
            self.navigationController?.pushViewController(locationsVC, animated: true)

        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        /*
        let autoLogin: NSString = self.getValueFromDefaults(key: "AutoLogin") as? NSString ?? "" as NSString
        
        let userDict: NSDictionary = self.getValueFromDefaults(key: "LoginDict") as? NSDictionary ?? NSDictionary()

        if autoLogin == "1" {

        }*/
        
        self.serviceRepository = ServiceRepository()
        self.serviceRepository?.delegate=self

    }
    
    // MARK: Button Actions
    
    @IBAction func submitBtnClicked(_sender: AnyObject) {
        
        userNameTxtFld.text = userNameTxtFld.text?.replacingOccurrences(of: " ", with: "")
        passwordTxtFld.text = passwordTxtFld.text?.replacingOccurrences(of: " ", with: "")
        
        if userNameTxtFld.text?.count==0 {
            let alertCont: UIAlertController = UIAlertController.init(title: "SocialDistance", message: "Please enter User Name", preferredStyle:.alert)
            
            //Create and an option action
            let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                //Do some other stuff
            }
            alertCont.addAction(nextAction)
            self.present(alertCont, animated: true, completion: nil)
        }else if passwordTxtFld.text?.count==0 {
            let alertCont: UIAlertController = UIAlertController.init(title: "SocialDistance", message: "Please enter User Password",preferredStyle:.alert)
            //Create and an option action
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                //Do some other stuff
            }
            alertCont.addAction(cancelAction)
            self.present(alertCont, animated: true, completion: nil)
        }else {
            
            let autoLoginStr = "1" as NSString
            self.setValueToDefaults(key: "AutoLogin", value: autoLoginStr)
            
               self.userNameTxtFld.text = ""
               self.passwordTxtFld.text = ""
               
               let storyboard = UIStoryboard(name:"Main", bundle: nil)
               
               let locationsVC: ViewController = storyboard.instantiateViewController(withIdentifier: "Locations") as! ViewController
               self.navigationController?.pushViewController(locationsVC, animated: true)
            
            /*
            let userDict: Dictionary = ["UserName": userNameTxtFld.text! as NSString,"Password":passwordTxtFld.text! as NSString]
            
            SVProgressHUD.show()
            
            let baseUrl = AppDelegate.baseURL()
            
            let urlStr = (baseUrl as String) + "login"
            
            self.serviceRepository?.postDetailsWithDictToURL(dict: userDict as NSDictionary, urlString: urlStr as String as NSString, serviceTypeStr: "Login")*/
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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

    
    func successResponseWithAnyType(responseType: Any, withServiceType: String) {
           //print(responseType)
           
           SVProgressHUD.dismiss()
           
           let responseDict: NSDictionary = responseType as! NSDictionary
                       
           //Nov 24th, 2017 vidhya
           
           if responseDict.object(forKey: "Code") == nil {
               
               let alertCont: UIAlertController = UIAlertController.init(title: "SocialDistance", message: "Unable to connect to server.",preferredStyle:.alert)
               //Create and an option action
               let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                   //Do some other stuff
               }
               alertCont.addAction(nextAction)
               self.present(alertCont, animated: true, completion: nil)
               
           }
           
           let successCode = responseDict.object(forKey: "Code") as! Int
           
           //print("Logged User Name is:" + userMembershipID.text!.capitalized)
           
           SVProgressHUD.dismiss()
           
           if successCode == 200 {
               
               //var userDefaults: UserDefaults = UserDefaults.standard
               /*
               let loggedUserDict = responseDict.object(forKey: "Data") as! NSDictionary
            
            UserDefaults.standard.setValue(loggedUserDict, forKey:"LoginDict")
            
            UserDefaults.standard.setValue("1", forKey: "AutoLogin") // May 30th, 2020 Vidya*/
            
            let loggedUserDict = responseDict.object(forKey: "Data") as! NSDictionary
            let autoLoginStr = "1" as NSString
            self.setValueToDefaults(key: "LoginDict", value: loggedUserDict)
            self.setValueToDefaults(key: "AutoLogin", value: autoLoginStr)
               
               } else {
                   
               }
                   
               self.userNameTxtFld.text = ""
               self.passwordTxtFld.text = ""
               
               let storyboard = UIStoryboard(name:"Main", bundle: nil)
               
               let locationsVC: ViewController = storyboard.instantiateViewController(withIdentifier: "Locations") as! ViewController
               self.navigationController?.pushViewController(locationsVC, animated: true)
                   
       }
       
       func failedResponseWithAnyType(responseType: Any, withServiceType: String) {
        
           print(responseType)
           
           SVProgressHUD.dismiss()
           
        /*
           let alertCont: UIAlertController = UIAlertController.init(title: "SocialDistance", message: "Unable to Connect to Server.",preferredStyle:.alert)
           //Create and an option action
           let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
               //Do some other stuff
           }
           alertCont.addAction(nextAction)
           self.present(alertCont, animated: true, completion: nil)*/
    }
    
    // MARK: TextField Delegate Methods
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }// return NO to disallow editing.
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        
    }// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag==1
        {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            
            let countdots = (textField.text?.components(separatedBy: ".").count)! - 1
            
            if countdots > 0 && string == "."
            {
                return false
            }
            return newLength <= 6
            
            /*
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 4*/
        } else if textField.tag==2
        {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 20
        }
        
        return true;
    }// return NO to not change text
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }// called when 'return' key pressed. return NO to ignore.
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.size.height >= 812 {
                    return
                }else if self.view.frame.origin.y == 88 {
                    return
                }else if self.view.frame.origin.y == 64{
                    self.view.frame.origin.y -= (keyboardSize.height-50)
               }
            }
        }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.size.height == 812 {
                //self.view.frame.origin.y -= (keyboardSize.height)
            }else if self.view.frame.origin.y == 88 {
                return
            }else if self.view.frame.origin.y != 64{
                self.view.frame.origin.y += (keyboardSize.height-50)
            }
        }
    }

}
