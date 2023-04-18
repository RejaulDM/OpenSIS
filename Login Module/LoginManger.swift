//
//  LoginManger.swift
//  NHAI
//
//  Created by Genius Consultants Ltd on 29/12/21.
//

import Foundation
import SVProgressHUD


protocol LoginMangerDelegate{
    
    func saveLoginData(dataLogIN:LoginShowData)
    func didGetEror(error:Error)
    
}

/*
struct LoginManger{
    
    var delegate:LoginMangerDelegate?
    
    func getLogin(_ userNameString:String,_ passwordString:String){
        let url = K.baseUrl + "AuthenticateWithEncryption?MasterID=\(userNameString)&Password=\(passwordString.base64Encoded()!)&IMEI=0&Version=v1&SecurityCode=\(K.securityCode)&DeviceID=112&DeviceType=I"
        print("***url",url)
        perfromRequst(url)
        
    }
    
    
    func perfromRequst(_ stringUrl:String){
        
        if let url = URL(string: stringUrl){
            let sision = URLSession(configuration: .default)
            let task = sision.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    
                    print("Login Error", error!)
                    delegate?.didGetEror(error: error!)
                    
                }
                
                if let safeData = data {
                    
                    if let logginData = pharseJaon(safeData){
                        
                        self.delegate?.saveLoginData(dataLogIN: logginData)
                        
                    }
                    
                }
                
                
            }
            
            task.resume()
            
        }
        
        
        func pharseJaon(_ loginData:Data) -> LoginShowData?{
            
            let jsonDecoder = JSONDecoder()
            
            do {
                
                let decoderData = try jsonDecoder.decode(LoginData.self, from: loginData)
                let responseStatus = decoderData.responseStatus
                let resonseText = decoderData.responseText
                let loginShowData = LoginShowData(loginStatus: responseStatus, responSeText: resonseText)
                
                if decoderData.responseStatus{
                    print("gell loging data ====== ",decoderData.responseData[0])
                    let aemClientID = decoderData.responseData[0].AEMClientID
                    UserDefaults.standard.set(aemClientID, forKey: "aemClientId")
                    let aemClientOfficeID = decoderData.responseData[0].AEMClientOfficeID
                    let aemConsultantID = decoderData.responseData[0].AEMConsultantID
                    let aemEployeId = decoderData.responseData[0].AEMEmployeeID
                    UserDefaults.standard.set(aemEployeId, forKey: "aemEmloyeeID")
                    let name =  decoderData.responseData[0].Name
                    UserDefaults.standard.set(name, forKey: "name")
                    let timeDate = decoderData.responseData[0].LoginDateTime
                    let loginID = decoderData.responseData[0].Code
                    let password = decoderData.responseData[0].Password
                    let ctcPage = decoderData.responseData[0].CtcPage
                    print("ctcPage======",ctcPage)
                    
                    UserDefaults.standard.set(aemClientID, forKey: K.LoginStoreData.aemClientID)
                    UserDefaults.standard.set(aemClientOfficeID, forKey: K.LoginStoreData.aemClientOfficeID)
                    UserDefaults.standard.set(aemConsultantID, forKey: K.LoginStoreData.aemConsultantID)
                    UserDefaults.standard.set(aemEployeId, forKey: K.LoginStoreData.aemEmployeeID)
                    UserDefaults.standard.set(name, forKey: K.LoginStoreData.userName)
                    UserDefaults.standard.set(timeDate, forKey: K.LoginStoreData.timeDate)
                    UserDefaults.standard.set(loginID, forKey: K.LoginStoreData.loginID)
                    UserDefaults.standard.set(password, forKey: K.LoginStoreData.password)
                    UserDefaults.standard.set(password, forKey: "key_password")
                    UserDefaults.standard.set(loginID, forKey: "key_loginID")
                    UserDefaults.standard.set(ctcPage, forKey: "key_ctcPage")
                    
                }
                
                return loginShowData
                
            } catch{
                
                delegate?.didGetEror(error: error)
                
                return nil
            }
            
        }
        
    }
    
}*/


