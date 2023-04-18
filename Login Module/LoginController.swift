//
//  LoginController.swift
//  NHAI
//
//  Created by Genius Consultants Ltd on 29/12/21.
//

import UIKit
import TransitionButton
import SVProgressHUD
import DTTextField
import Alamofire
import SwiftyJSON

class LoginController: UIViewController,UITextFieldDelegate {
    

    
    @IBOutlet weak var submitButton: TransitionButton!
    
    @IBOutlet weak var editSchoolWebURL: DTTextField!
    
    @IBOutlet weak var textUserName: DTTextField!
    @IBOutlet weak var textPassword: DTTextField!
    
    @IBOutlet weak var btnPassShowHide: UIButton!
    
    @IBOutlet weak var btnLogin: TransitionButton!
    
    @IBOutlet weak var viewEditURL: UIView!
    
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewEmailAddress: UIView!
    
    var iconClick1 = true
    let iconHide = UIImage(named: "hide") as UIImage?
    let iconShow = UIImage(named: "show") as UIImage?
    
    var iconClick = true
    let checkImg = UIImage(named: "check") as UIImage?
    let uncheckImg = UIImage(named: "checkbxx") as UIImage?
    
   // var loginManager = LoginManger()
    var passrordKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            view.backgroundColor = .white
        }
        uiUpdate()
        //loginManager.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let SubURL  = UserDefaults.standard.string(forKey: "Key_WebURL") ?? ""
        let Key_Password  = UserDefaults.standard.string(forKey: "Key_Password") ?? ""
        let storeUserid  = UserDefaults.standard.string(forKey: "Key_UserName") ?? ""
        
        textUserName.text = storeUserid
        textPassword.text = Key_Password
        editSchoolWebURL.text = SubURL
        
        if storeUserid == ""{
            
            editSchoolWebURL.text = "https://fedsis.doe.fm/"
            
            textUserName.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
            textPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
        
    }
   
    
    @IBAction func btnTappedPassShowHide(_ sender: Any) {
   
        if(iconClick1 == true) {
            btnPassShowHide.setBackgroundImage(iconShow, for:.normal)
            textPassword.isSecureTextEntry = false
        } else {
            btnPassShowHide.setBackgroundImage(iconHide, for:.normal)
            textPassword.isSecureTextEntry = true
        }
        
        iconClick1 = !iconClick1
    }
    
    @IBAction func pressButtonLogin(_ sender: Any) {
        loginValidation()
    }
    
    
    @IBAction func forGotPassword(_ sender: Any) {
    
        
        let storyboard = UIStoryboard(name: K.LoginStoryBoard, bundle: nil)
        let contollerName = storyboard.instantiateViewController(withIdentifier: "")
        self.present(contollerName, animated: true, completion: nil)
    }
    
    
}


// UI Design

extension LoginController{
    
  private func uiUpdate(){
       
      // Create a padding view for padding on left
     /* textUserName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: textUserName.frame.height))
      textUserName.leftViewMode = .always
      
      // Create a padding view for padding on left
      paswwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: paswwordTextField.frame.height))
      paswwordTextField.leftViewMode = .always */
        
      textUserName.borderStyle = .none
      textPassword.borderStyle = .none
      
      textUserName.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
      textPassword.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
      
  
      
      
      self.submitButton.layer.cornerRadius = 8
      
      viewEditURL.layer.cornerRadius = 8
      
      self.viewEmailAddress.layer.borderWidth = 2
      self.viewEmailAddress.layer.cornerRadius = 8
      self.viewEmailAddress.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      
      self.viewPassword.layer.borderWidth = 2
      self.viewPassword.layer.cornerRadius = 8
      self.viewPassword.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      
      // Create a padding view for padding on left
      textUserName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textUserName.frame.height))
      textUserName.leftViewMode = .always
      
      // Create a padding view for padding on left
      textPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textPassword.frame.height))
      textPassword.leftViewMode = .always
      
      // Create a padding view for padding on left
      editSchoolWebURL.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: editSchoolWebURL.frame.height))
      editSchoolWebURL.leftViewMode = .always
      
      
        //self.userIDTextFileld.customTextField()
        //self.userIDTextFileld.placeholder = LoginConstatnt.userIDHint
        
        //self.paswwordTextField.customTextField()
        //self.paswwordTextField.placeholder = LoginConstatnt.passwordIDHint
        
        //self.submitButton.setTitle(LoginConstatnt.buttonTitle, for: .normal)
        //self.submitButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        //self.submitButton.setTitleColor(.white, for: .normal)
        
    }
    
    
    
}


// Login Field Validation

extension LoginController {
    
  private func loginValidation(){
        
        if (textUserName.text?.isEmpty)!{
            self.displayAlertMessage(messageToDisplay: "Please Enter Email Address")
        }
        
        else if (textPassword.text?.isEmpty)!{
            self.displayAlertMessage(messageToDisplay: "Please Enter Password")
            
        }
        
        else {
            
            //callAPILogin()
            CallApiPasswordKey()
            
            //self.submitButton.startAnimation()
            //loginManager.getLogin(userIDTextFileld.text!, paswwordTextField.text!)
        }
        
    }
    
    func CallApiPasswordKey(){
        
        if (editSchoolWebURL.text?.isEmpty)!{
            self.displayAlertMessage(messageToDisplay: "Please Enter Web Address")
            
        }else{
            
            let passtext = editSchoolWebURL.text!
            let start = passtext.components(separatedBy: ":")
            let getUrl : String = start[1]
            print("getUrl====",getUrl)
            UserDefaults.standard.set(passtext, forKey: "Key_SubURL")
            
            let tname = getUrl.components(separatedBy: "//")
            let tantName : String = tname[1]
            let gtname = tantName.components(separatedBy: ".")
            let gtantName : String = gtname[0]
            print("get tantName==",gtantName)
            UserDefaults.standard.set(gtantName, forKey: "Key_TentName")
            
            let GetSubURL = UserDefaults.standard.string(forKey: "Key_SubURL")
            print("GetSubURL==",GetSubURL)
            let TentName = UserDefaults.standard.string(forKey: "Key_TentName")
            print("Get TentName==",TentName)
            
            let baseUrl = GetSubURL! + ":8088/" + TentName! + "/"
            print("baseUrl====",baseUrl)
            UserDefaults.standard.set(baseUrl, forKey: "Key_BaseURL")
            let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL")
            print("Get BaseURL==",BaseURL)
          
            btnLogin.startAnimation()
            SVProgressHUD.show()
            
            let parameters = [
                "": ""
            ] as [String : Any];
            
            print("param Key==",parameters)
            let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            print("jsonData==",jsonData)
            
            let jsonString1 = String(data: jsonData, encoding: String.Encoding.ascii)!
            let urlString = baseUrl + "User/getEncryptPassword?password=" + textPassword.text!
            print("URL ValidateLogin=====",urlString)
            let url = URL(string: urlString)!
            var request = URLRequest(url: url)
            print("request ValidateLogin===",request)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            Alamofire.request(request).responseString {response in
                switch response.result {
                case .success(let data):
                    SVProgressHUD.dismiss()
                    self.btnLogin.startAnimation()
                    let json = JSON(data)
                    print("json ValidateLogin====",json)
                    let passKey = json.stringValue
                    print("passKey==",passKey)
                    self.passrordKey = passKey
                    self.callAPILogin()
                    
                    break
                case .failure(let error):
                    
                    SVProgressHUD.dismiss()
                    print("Request failed with error: \(error)")
                    break
                }
                
                
            }
        }
    }
   
     func callAPILogin(){
         
         let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
         let TentName = UserDefaults.standard.string(forKey: "Key_TentName") ?? ""
         //"nickson@yopmail.com"
         btnLogin.startAnimation()
         SVProgressHUD.show()
         
         let parameters = [
            "tenantid":"1e93c7bf-0fae-42bb-9e09-a1cedc8c0355",
             "userid":0,
             "useraccesslog":[
             "ipaddress":"122.163.76.226",
             "emailaddress":textUserName.text!
             ],
             "_tenantname":TentName,
             "password":passrordKey!,
             "email":textUserName.text!,
             "isMobileLogin":true,
             "schoolId":"",
             "_userName":"",
             "_token":""
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
                 self.btnLogin.startAnimation()
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
                 let membershipId = json["membershipId"].stringValue
                 let token = json["_token"].stringValue
                 let tenantName = json["_tenantName"].stringValue
                 let userPhoto = json["userPhoto"].stringValue
                 let message = json["_message"].stringValue
                 
                 if LoginStatus == "false"{
                     UserDefaults.standard.set(userId, forKey: "KEY_USERID")
                     UserDefaults.standard.set(self.textPassword.text!, forKey: "Key_Password")
                     UserDefaults.standard.set(self.textUserName.text!, forKey: "Key_UserName")
                     UserDefaults.standard.set(email, forKey: "Key_Email")
                     UserDefaults.standard.set(tenantId, forKey: "Key_TenantId")
                     UserDefaults.standard.set(schoolId, forKey: "Key_SchoolID")
                     UserDefaults.standard.set(name, forKey: "Key_Name")
                     UserDefaults.standard.set(membershipName, forKey: "Key_MembershipName")
                     UserDefaults.standard.set(membershipType, forKey: "Key_MembershipType")
                     UserDefaults.standard.set(membershipId, forKey: "Key_MembershipID")
                     UserDefaults.standard.set(token, forKey: "Key_Token")
                     UserDefaults.standard.set(tenantName, forKey: "Key_TenantName")
                     
                     UserDefaults.standard.set(userPhoto, forKey: "Key_UserPhoto")
                     
                     UserDefaults.standard.set(self.editSchoolWebURL.text!, forKey: "Key_WebURL")
                     
                     
                     
                     let storyboard = UIStoryboard(name: K.DashbordStroryBoard, bundle: nil)
                     let contollerName = storyboard.instantiateViewController(withIdentifier: "DashboardNav")
                     self.present(contollerName, animated: true, completion: nil)
                     //self.CallApiGetLogo()
                 }else{
                     self.displayAlertMessage(messageToDisplay: message)
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
