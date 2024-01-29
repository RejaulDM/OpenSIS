//
//  Connstant.swift
//  NHAI
//
//  Created by Genius Consultants Ltd on 29/12/21.
//

import Foundation

struct K {
    
    static let LoginStoryBoard  = "Login"
    static let DashbordStroryBoard = "Dashboard"
    static let SchoolsStoryBoard = "Schools"
    static let ClassesStoryboard = "Classes"
    static let attendanceStoryboard = ""
   static let goToAttendanceSubmitController = ""
    
    static let SubURL = UserDefaults.standard.string(forKey: "Key_SubURL")
    static let TentName = UserDefaults.standard.string(forKey: "Key_TentName")
    
    //static let baseUrl = "https://fedsis.doe.fm:8088/fedsis/"
    
    //static let baseUrl = SubURL! + ":8088/" + TentName! + "/"
    
    static let baseUrlImage = ""
    
    static let globalError = "Please try again after some time"
    
    struct LoginStoreData {
        
        static let aemClientID = "ClientID"
        static let aemClientOfficeID = "aemClientOfiiceID"
        static let aemConsultantID = "aemConsultantID"
        static let aemEmployeeID = "aemEmployeID"
        static let userName = "name"
        static let timeDate = "timeDate"
        static let loginID = "loginID"
        static let password = "password"
        
    }
    
}
