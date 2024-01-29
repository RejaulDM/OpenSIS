//
//  ForgotPasswordManager.swift
//  NHAI
//
//  Created by Abu Sahid Reza on 06/02/22.
//

import Foundation
import UIKit
import Alamofire

protocol ForgotPasswordDelegate {
    
    func forgotPasswordData(forgetData:ForgotPasswordData)
}


class ForgotPasswordManager{
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    var delegate:ForgotPasswordDelegate?
    
    func forgotpasswordApiHit(userID:String){
        
        let stringUrl = BaseURL + "GCl_ForgotPassword?MasterID=\("userID")&SecurityCode=\("K.securityCode")"
        
              
        
                  Alamofire.request(stringUrl, method: .get, parameters:nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
        
                          switch(response.result) {
        
                          case .success(_):
        
                            
        
                              if let data = response.result.value{
        
        
                                  let json = data as? [String: Any]
        
                                  print("myJSon value:",json!)
        
                                  let responseStatus = json!["responseStatus"] as! Bool
        
                                  let responseText = json!["responseText"] as? String
        
                               
                                let data = ForgotPasswordData(responseStatus: responseStatus, responseText: responseText)
                                
                                self.delegate?.forgotPasswordData(forgetData: data)
        
        
        
        
                              }
        
                              break
        
        
                          case .failure(_):
        
                         
                              print("faliure",response.result.error!)
        
                             
        
                              break
        
        
                          }
        
                      }
        
        
        
        
        
        
        
    }
    
    
    
    
}

struct ForgotPasswordData {
    
    var responseStatus:Bool?
    var responseText: String?
    
    
}
