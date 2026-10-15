//
//  HelperProtocol.swift
//  EPGC
//
//  Created by Shivkumar G on 8/30/17.
//  Copyright © 2017 Shivkumar G. All rights reserved.
//

import Foundation

protocol HelperProtocol {
    
func successResponseWithAnyType(responseType: Any, withServiceType: String)
    
func failedResponseWithAnyType(responseType: Any, withServiceType: String)
    
//func failedResponseWithAnyType(responseType: Any, withServiceType: String)
    
}
