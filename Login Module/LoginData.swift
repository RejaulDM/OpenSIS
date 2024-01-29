//
//  LoginData.swift
//  NHAI
//
//  Created by Abu Sahid Reza on 30/12/21.
//

import Foundation

struct LoginData:Codable{
    
    let responseText: String
    let responseStatus: Bool
    let responseCode: String
    let responseData: [ResponseData]
    
}

struct ResponseData:Codable{
    
    let AEMClientID:String
    let AEMClientOfficeID:String
    let AEMConsultantID:String
    let AEMEmployeeID:String
    let Name:String
    let LoginDateTime:String
    let Code:String
    let Password:String
    let CtcPage:String
    
}
