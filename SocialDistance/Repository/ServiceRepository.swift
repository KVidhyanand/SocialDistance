//
//  ServiceRepository.swift
//  EPGC
//
//  Created by Shivkumar G on 8/30/17.
//  Copyright © 2017 Shivkumar G. All rights reserved.
//

import UIKit

class ServiceRepository: NSObject {
    
    //let delegate: HelperProtocol = HelperProtocol.self as! HelperProtocol
    
    var delegate: HelperProtocol?
    
    func getDetailsFromURL(urlString: String, serviceTypeStr: String) {
    
        let finalURL = urlString.replacingOccurrences(of: " ", with: "")
        var request = URLRequest(url: URL(string: finalURL as String)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("9C6ACE73-1D10-44CB-938A-D31CD7AF011", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(60)
        configuration.timeoutIntervalForResource = TimeInterval(60)
        session.dataTask(with: request) {data, response, err in
            print("@@@@@@@ URL is" +  finalURL)
            
            if(err != nil){
                print("error")
                self.delegate?.failedResponseWithAnyType(responseType: err!, withServiceType: serviceTypeStr as String)
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    
                    OperationQueue.main.addOperation({
                        print(json)
                        
                        self.delegate?.successResponseWithAnyType(responseType: json, withServiceType: serviceTypeStr as String)
                    })
                    
                }catch let error as NSError{
                    print(error)
                    
                    self.delegate?.failedResponseWithAnyType(responseType: error, withServiceType: serviceTypeStr)
                }
            }
            
            }.resume()
    }
    
    func getDetailsWithDictFromURL(dict: NSDictionary, urlString: NSString, serviceTypeStr: NSString) {
        //let jsonData = try? JSONSerialization.data(withJSONObject: dict)
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        var request = URLRequest(url: URL(string: urlString as String)!)
        request.httpMethod = "GET"
        request.httpBody=jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("9C6ACE73-1D10-44CB-938A-D31CD7AF011", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(60)
        configuration.timeoutIntervalForResource = TimeInterval(60)
        session.dataTask(with: request) {data, response, err in
            //print("Entered the completionHandler")
            
            if(err != nil){
                print("error")
                self.delegate?.failedResponseWithAnyType(responseType: err!, withServiceType: serviceTypeStr as String)
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    
                    OperationQueue.main.addOperation({
                        //print(json)
                        
                        self.delegate?.successResponseWithAnyType(responseType: json, withServiceType: serviceTypeStr as String)
                    })
                    
                }catch let error as NSError{
                    print(error)
                    
                    self.delegate?.failedResponseWithAnyType(responseType: error, withServiceType: serviceTypeStr as String)
                }
            }
            
            }.resume()

    }
    
    func postDetailsToURL(urlString: NSString, serviceTypeStr: NSString) {
        
        var request = URLRequest(url: URL(string: urlString as String)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("9C6ACE73-1D10-44CB-938A-D31CD7AF011", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(60)
        configuration.timeoutIntervalForResource = TimeInterval(60)
        session.dataTask(with: request) {data, response, err in
            //print("Entered the completionHandler")
            
            if(err != nil){
                print("error")
                self.delegate?.failedResponseWithAnyType(responseType: err!, withServiceType: serviceTypeStr as String)
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    
                    OperationQueue.main.addOperation({
                        //print(json)
                        
                        self.delegate?.successResponseWithAnyType(responseType: json, withServiceType: serviceTypeStr as String)
                    })
                    
                }catch let error as NSError{
                    print(error)
                    
                    self.delegate?.failedResponseWithAnyType(responseType: error, withServiceType: serviceTypeStr as String)
                }
            }
            
            }.resume()
    }
    
    func postDetailsWithDictToURL(dict: NSDictionary, urlString: NSString, serviceTypeStr: NSString) {
        
        //let jsonData = try? JSONSerialization.data(withJSONObject: dict)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)//prettyPrinted
        
        //print("Post URL string:" +  (urlString as String))
        //print("Parameters are:")
        //print((dict as Dictionary))
    
        //let fullBase64String = "data:image/png;base64,\(dataImage))"
        
        //data:image/png;base64,
        
        var request = URLRequest(url: URL(string: urlString as String)!)
        request.httpMethod = "POST"
        request.httpBody=jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("9C6ACE73-1D10-44CB-938A-D31CD7AF011", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(60)
        configuration.timeoutIntervalForResource = TimeInterval(60)
        
        session.dataTask(with: request) {data, response, err in
            //print("Entered the completionHandler")
            
            if(err != nil){
                print("error")
                self.delegate?.failedResponseWithAnyType(responseType: err!, withServiceType: serviceTypeStr as String)
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    
                    OperationQueue.main.addOperation({
                        //print(json)
                        
                        self.delegate?.successResponseWithAnyType(responseType: json, withServiceType: serviceTypeStr as String)
                    })
                    
                }catch let error as NSError{
                    print(error)
                    
                    self.delegate?.failedResponseWithAnyType(responseType: error, withServiceType: serviceTypeStr as String)
                }
            }
            
            }.resume()
    }
    
    func putDetailsWithDictToURL(dict: NSDictionary, urlString: NSString, serviceTypeStr: NSString) {
        
        //let jsonData = try? JSONSerialization.data(withJSONObject: dict)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)//prettyPrinted
        
        //print("Post URL string:" +  (urlString as String))
        //print("Parameters are:")
        //print((dict as Dictionary))
        
        //let fullBase64String = "data:image/png;base64,\(dataImage))"
        
        //data:image/png;base64,
        
        var request = URLRequest(url: URL(string: urlString as String)!)
        request.httpMethod = "PUT"
        request.httpBody=jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("9C6ACE73-1D10-44CB-938A-D31CD7AF011", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(60)
        configuration.timeoutIntervalForResource = TimeInterval(60)
        
        session.dataTask(with: request) {data, response, err in
            //print("Entered the completionHandler")
            
            if(err != nil){
                print("error")
                self.delegate?.failedResponseWithAnyType(responseType: err!, withServiceType: serviceTypeStr as String)
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    
                    OperationQueue.main.addOperation({
                        //print(json)
                        
                        self.delegate?.successResponseWithAnyType(responseType: json, withServiceType: serviceTypeStr as String)
                    })
                    
                }catch let error as NSError{
                    print(error)
                    
                    self.delegate?.failedResponseWithAnyType(responseType: error, withServiceType: serviceTypeStr as String)
                }
            }
            
            }.resume()
    }
    
    func postImageWithDictToURL(dict: NSDictionary, base64ImageStr: NSString, urlString: NSString, serviceTypeStr: NSString) {
        
        //let jsonData = try? JSONSerialization.data(withJSONObject: dict)
                
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        var request = URLRequest(url: URL(string: urlString as String)!)
        request.httpMethod = "POST"
        request.httpBody=jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("9C6ACE73-1D10-44CB-938A-D31CD7AF011", forHTTPHeaderField: "Authorization")
        //request.addValue(base64ImageStr as String, forHTTPHeaderField: "strbase64")
        let session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(60)
        configuration.timeoutIntervalForResource = TimeInterval(60)
        session.dataTask(with: request) {data, response, err in
            //print("Entered the completionHandler")
            
            if(err != nil){
                print("error")
                self.delegate?.failedResponseWithAnyType(responseType: err!, withServiceType: serviceTypeStr as String)
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    
                    OperationQueue.main.addOperation({
                        //print(json)
                        
                        self.delegate?.successResponseWithAnyType(responseType: json, withServiceType: serviceTypeStr as String)
                    })
                    
                }catch let error as NSError{
                    print(error)
                    
                    self.delegate?.failedResponseWithAnyType(responseType: error, withServiceType: serviceTypeStr as String)
                }
            }
            
            }.resume()
    }
    
    func postDetailsWithArrToURL(arr: NSMutableArray, urlString: NSString, serviceTypeStr: NSString) {
                
        let jsonData = try? JSONSerialization.data(withJSONObject: arr, options: .prettyPrinted)//prettyPrinted
        
        //print("Post URL string:" +  (urlString as String))
        //print("Parameters are:")
        //print((arr as NSMutableArray))
        
        //request.httpBody = postString.data(using: String.Encoding.utf8, allowLossyConversion: true)

        var request = URLRequest(url: URL(string: urlString as String)!)
        request.httpMethod = "POST"
        request.httpBody=jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("9C6ACE73-1D10-44CB-938A-D31CD7AF011", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(60)
        configuration.timeoutIntervalForResource = TimeInterval(60)
        
        session.dataTask(with: request) {data, response, err in
            //print("Entered the completionHandler")
            
            if(err != nil){
                print("error")
                self.delegate?.failedResponseWithAnyType(responseType: err!, withServiceType: serviceTypeStr as String)
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    
                    OperationQueue.main.addOperation({
                        //print(json)
                        
                        self.delegate?.successResponseWithAnyType(responseType: json, withServiceType: serviceTypeStr as String)
                    })
                    
                }catch let error as NSError{
                    print(error)
                    
                    self.delegate?.failedResponseWithAnyType(responseType: error, withServiceType: serviceTypeStr as String)
                }
            }
            
            }.resume()
    }


}
