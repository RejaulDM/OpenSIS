//
//  SplashPage.swift
//  NHAI
//
//  Created by Genius Consultants Ltd on 13/12/21.
//

import UIKit
import TransitionButton
import SVProgressHUD
import DTTextField
import Alamofire
import SwiftyJSON


class SplashPage: UIViewController {
    

    let storeUserID = UserDefaults.standard.string(forKey: "Key_UserName")
    let storePassword = UserDefaults.standard.string(forKey: "Key_Password")
   
    //private var loginManager = LoginManger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //https://fedsis.doe.fm/
        
        
        
        allGetSplash()
        
    }
    
    @objc func goToNextController(){
        
        if (storeUserID == nil){
            let storyboard = UIStoryboard(name: K.LoginStoryBoard, bundle: nil)
            let contollerName = storyboard.instantiateViewController(withIdentifier: "SubmitWebURL")
            self.present(contollerName, animated: true, completion: nil)
            
        }
        
        else {
            
            let storyboard = UIStoryboard(name: K.LoginStoryBoard, bundle: nil)
            let contollerName = storyboard.instantiateViewController(withIdentifier: "SubmitWebURL")
            self.present(contollerName, animated: true, completion: nil)
            
            //callAPILogin()
            
           /* let storyboard = UIStoryboard(name: K.DashbordStroryBoard, bundle: nil)
            let contollerName = storyboard.instantiateViewController(withIdentifier: "DashboardNav")
            self.present(contollerName, animated: true, completion: nil)*/
            
        }
        
        
    }
    
    func allGetSplash(){
        
        perform(#selector(goToNextController),with: nil, afterDelay: 3)
        
    }
    
    
     func callAPILogin(){
         let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
         SVProgressHUD.show()
         
         let parameters = [
            "tenantId": "1E93C7BF-0FAE-42BB-9E09-A1CEDC8C0355",
            "userId": "0",
            "_tenantName": "fedsis",
            "password": "cB3563YklO+J+c2Y6ULF16soc15ezJIh/XeXFnEqhQME3QNSGvUsiylZeBmRqowW",
            "email": "nickson@yopmail.com",
            "schoolId": nil,
            "_userName": "",
            "_token": nil
             ] as [String : Any];
         
         print("param Login==",parameters)
         let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
         print("jsonData==",jsonData)
         
         let jsonString1 = String(data: jsonData, encoding: String.Encoding.ascii)!
         //print("jsonString==",jsonString1)
         
         let urlString = BaseURL + "User/ValidateLogin"
         print("URL ValidateLogin=====",urlString)
         let url = URL(string: urlString)!
         var request = URLRequest(url: url)
         print("request ValidateLogin===",request)
         request.httpMethod = HTTPMethod.post.rawValue
         request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
         request.httpBody = jsonData
         Alamofire.request(request).responseJSON {response in
             switch response.result {
             case .success(let data):
                 SVProgressHUD.dismiss()
                 //print("Login Response====",response)
                 let json = JSON(data)
                 print("json ValidateLogin====",json)
                 
                 let LoginStatus = json["_failure"].stringValue
                 print("LoginStatus==",LoginStatus)
                 
                 let userId = json["userId"].stringValue
                 let email = json["email"].stringValue
                 let tenantId = json["tenantId"].stringValue
                 let schoolId = json["schoolId"].stringValue
                 let name = json["name"].stringValue
                 let membershipName = json["membershipName"].stringValue
                 let membershipType = json["membershipType"].stringValue
                 let token = json["_token"].stringValue
                 let tenantName = json["_tenantName"].stringValue
                 
                 print("userId===",userId,"email===",email,"tenantId===",tenantId,"schoolId===",schoolId,"name===",name,"tenantName===",tenantName)
                 
                 if LoginStatus == "false"{
                     UserDefaults.standard.set(userId, forKey: "Key_UserID")
                     UserDefaults.standard.set(email, forKey: "Key_Email")
                     UserDefaults.standard.set(tenantId, forKey: "Key_TenantId")
                     UserDefaults.standard.set(schoolId, forKey: "Key_SchoolID")
                     UserDefaults.standard.set(name, forKey: "Key_Name")
                     UserDefaults.standard.set(membershipName, forKey: "Key_MembershipName")
                     UserDefaults.standard.set(membershipType, forKey: "Key_MembershipType")
                     UserDefaults.standard.set(token, forKey: "Key_Token")
                     UserDefaults.standard.set(tenantName, forKey: "Key_TenantName")
                     
                     let storyboard = UIStoryboard(name: K.DashbordStroryBoard, bundle: nil)
                     let contollerName = storyboard.instantiateViewController(withIdentifier: "DashboardNav")
                     self.present(contollerName, animated: true, completion: nil)
                 }else{
                     self.displayAlertMessage(messageToDisplay: K.globalError)
                 }
                 
                 break
             case .failure(let error):
                 
                 SVProgressHUD.dismiss()
                 print("Request failed with error: \(error)")
                 break
             }
             
             
         }
     }
    
}




