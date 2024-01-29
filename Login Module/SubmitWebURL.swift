//
//  SubmitWebURL.swift
//  OpenSIS
//
//  Created by Rejaul on 11/20/22.
//

import UIKit
import DTTextField
import TransitionButton
import SVProgressHUD
import SwiftyJSON
import Alamofire

class SubmitWebURL: UIViewController {

    
    @IBOutlet weak var textURL: DTTextField!
    
    @IBOutlet weak var submitButton: TransitionButton!
    
    
    @IBOutlet weak var iconLogo: UIImageView!
    
    @IBOutlet weak var viewURL: UIView!
    
    var apiweburl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconLogo.layer.cornerRadius = iconLogo.frame.height/2
        iconLogo.clipsToBounds = true
        
        textURL.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        let Key_BaseURL  = UserDefaults.standard.string(forKey: "Key_WebURL") ?? ""
        
        if Key_BaseURL == ""{
            //textURL.text = "https://fedsis.doe.fm/"
            textURL.attributedPlaceholder = NSAttributedString(string: "Please Enter Web Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }else{
            textURL.text = Key_BaseURL
           /* textURL.attributedPlaceholder = NSAttributedString(string: "PACIFIC EMIS web address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]) */
        }
       
        self.textURL.layer.borderWidth = 2
        self.textURL.layer.cornerRadius = 8
        self.textURL.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        
        // Create a padding view for padding on left
        textURL.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textURL.frame.height))
        textURL.leftViewMode = .always
        
        //uiUpdate()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnTappedSubmit(_ sender: Any) {
        
        if (textURL.text?.isEmpty)!{
            self.displayAlertMessage(messageToDisplay: "Please Enter Web Address")
            
        }else{
            
            callApiGetURL()
                
            }
    }
    

}


// UI Design

extension SubmitWebURL{
    
  private func uiUpdate(){
      textURL.borderStyle = .none
      
      textURL.attributedPlaceholder = NSAttributedString(string: "openSIS web address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
      
     
      self.submitButton.layer.cornerRadius = 8
      
      self.viewURL.layer.borderWidth = 2
      self.viewURL.layer.cornerRadius = 8
      self.viewURL.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
     }
    
    //https://test.opensis.com/assets/config.json
    //https://opensis-prod-api.azurewebsites.net/test/User/ValidateLogin
    
    
    func callApiGetURL(){
        SVProgressHUD.show()
        let geturl = textURL.text!
        guard let url = URL(string: geturl + "/assets/config.json") else {
            return }
        print("URL===",url)
        let session = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let response = response{
                print(response)
            }
            if let data = data {
                print(data)
                do{
                    SVProgressHUD.dismiss()
                    let json3 = try JSONSerialization.jsonObject(with: data, options: [])
                    if let json1 = try? JSON(data: data) {
                        
                        print("JSON Personal Details==",json1)
                        
                       
                        let apiURL = json1["apiURL"].stringValue
                        self.apiweburl = apiURL
                        UserDefaults.standard.set(apiURL, forKey: "Key_WebAddress")
                        //UserDefaults.standard.set(apiURL, forKey: "Key_BaseURL")
                        
                        UserDefaults.standard.set(geturl, forKey: "Key_InputWebAddress")
                        DispatchQueue.main.async {
                            self.CallApiCompanyDetails()
                       /* let storyboard = UIStoryboard(name: "Login", bundle: nil)
                        let contollerName = storyboard.instantiateViewController(withIdentifier: "Login1")
                        self.present(contollerName, animated: true, completion: nil) */
                        }
                        
                    }
                    
                }catch{
                    SVProgressHUD.dismiss()
                    print(error)
                }
            }
            }.resume()
    }
    
    
    func CallApiCompanyDetails(){
        let getwebadd = textURL.text!
        let tname = getwebadd.components(separatedBy: "//")
        let tantName : String = tname[1]
        let gtname = tantName.components(separatedBy: ".")
        let gtantName : String = gtname[0]
        print("get tantName==",gtantName)
        
        SVProgressHUD.show()
            
            let parameters = [
                "tenant": [
                    "id": 0,
                    "tenantName": gtantName,
                    "tenantId": "",
                    "isActive": false,
                    "tenantFooter": "",
                    "tenantLogo": "",
                    "tenantLogoIcon": "",
                    "tenantFavIcon": "",
                    "tenantSidenavLogo": ""
                  ],
                  "IsMobileLogin":true
                ] as [String : Any];
            
            print("param Company Details==",parameters)
            let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString1 = String(data: jsonData, encoding: String.Encoding.ascii)!
            let urlString = apiweburl + "api/CatalogDB/getAvailableTenantDetails"
            print("urlString TenantDetails===",urlString)
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
                    let json = JSON(data)
                    //print("json Company Details====",json)
                    let passKey = json.stringValue
                    
                    //let base64Encoded = json.stringValue
                    let base641 = json.stringValue
                   var trs = base641.base64Decoded1()
                        print("Company Details Json==== \"\(trs)\"")
                  var basestr = "\(trs!)"
                    print("basestr===",basestr)
                    if let list = self.convertToDictionary(text: basestr) as? AnyObject {
                        //print("list Pas create====",list);
                        let getObject = list["tenant"] as? AnyObject
                        //print("getObject====",getObject);
                        
                        let schoolname = getObject?["SchoolName"] as? String
                        let TenantId = getObject?["TenantId"] as? String
                        let TenantLogo = getObject?["TenantLogo"] as? String
                        let TenantName = getObject?["TenantName"] as? String
                        let TenantFavIcon = getObject?["TenantFavIcon"] as? String
                        print("schoolname===",schoolname)
                        
                        UserDefaults.standard.set(schoolname, forKey: "Key_Schoolname")
                        UserDefaults.standard.set(TenantId, forKey: "Key_TenantId")
                        UserDefaults.standard.set(TenantLogo, forKey: "Key_TenantLogo")
                        UserDefaults.standard.set(TenantName, forKey: "Key_TenantName")
                        UserDefaults.standard.set(TenantFavIcon, forKey: "Key_TenantFavIcon")
                        
                        let storyboard = UIStoryboard(name: "Login", bundle: nil)
                         let contollerName = storyboard.instantiateViewController(withIdentifier: "Login1")
                         self.present(contollerName, animated: true, completion: nil)
                        
                   }
                    
                    break
                case .failure(let error):
                    
                    SVProgressHUD.dismiss()
                    print("Request failed with error: \(error)")
                    break
                }
                
                
            }
        }
    
    
     func convertToDictionary(text: String) -> Any? {
         if let data = text.data(using: .utf8) {
              do {
                  return try JSONSerialization.jsonObject(with: data, options: []) as? Any
              } catch {
                  print(error.localizedDescription)
              }
          }

          return nil

     }
    }
extension String {
//: ### Base64 encoding a string
    func base64Encoded1() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }

//: ### Base64 decoding a string
    func base64Decoded1() -> String? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
extension String {
    /// Encode a String to Base64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    /// Decode a String from Base64. Returns nil if unsuccessful.
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
/*{
 "apiURL":"https://opensis-prod-api.azurewebsites.net/",
 "microsoftLoginURL" : "https://login.microsoftonline.com/",
 "newItems": ["Behavior Fields", "Behavior & Discipline"],
 "systemOffline" : false,
 "offlineMessage" : "",
 "systemNotification" : "",
 "starredItems": ["Billing (Coming Soon)"]
} */
