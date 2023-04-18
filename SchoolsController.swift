//
//  SchoolsController.swift
//  OpenSIS
//
//  Created by Rejaul on 11/30/22.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SchoolsController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    var arrSchoolList = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
        self.tableView.tableFooterView = UIView()
        
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        tableView.reloadData()
        
        callAPIGetSchoolsList()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func btnTappedHome(_ sender: Any) {
    
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardNav")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnTappedClass(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ClassesController")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnTappedSchedule(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardNav")
        self.present(controller, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSchoolList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SchoolsCell
        
        let item = arrSchoolList[indexPath.row]
        
        cell.lblSchoolsName.text = item["schoolName"].stringValue
        
        let streetAdd1 = item["streetAddress1"].stringValue
        let streetAdd2 = item["streetAddress2"].stringValue
        let city = item["city"].stringValue
        let zip = item["zip"].stringValue
        let country = item["country"].stringValue
        
        cell.lblSchoolsDec.text = streetAdd1 + " " + streetAdd2 + " " + city + ", " + zip + ", " + country
        
       /* let imgPath = item.ProductImageName
        let InImgURL = imgPath
        let urlStringImg = InImgURL!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        cell.imgItem.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgItem.sd_setImage(with: URL(string: urlStringImg), placeholderImage: UIImage(named: "")) */
        
        
        //transparents table view cell
            cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = arrSchoolList[indexPath.row]
        
        let schoolID = item["schoolId"].stringValue
        UserDefaults.standard.set(schoolID, forKey: "Key_SelectSchoolID")
        
        let schoolname = item["schoolName"].stringValue
        UserDefaults.standard.set(schoolname, forKey: "Key_SchoolName")
        print("schoolname====",schoolname)
        
        let storyBoard = UIStoryboard(name: "Schools", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SchoolsDetailsInfo")
        self.present(controller, animated: true, completion: nil)
        
    }

}


extension SchoolsController{
    
    
    // ====== All Schoils Lists
    
    func callAPIGetSchoolsList(){
        
        SVProgressHUD.show()
        
        let parameters = [
            "schoolId": storeSchoolID,
            "pageNumber":0,
            "pageSize":0,
            "sortingModel": nil,
            "filterParams": nil,
            "includeInactive":false,
            "emailAddress":storeEmail,
            "tenantId":storeTenantID,
            "_tenantName":storeTenantName,
            "_token":storeToken,
            "_userName":storeName,
            ] as [String : Any];
        print("Param Schools==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "School/getAllSchoolList"
        print("URL Schools==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        print("request Schools===",request)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                //print("SchoolsResponse===",response)
                let json = JSON(data)
                print("json Schools==",json)
                let getArrJson = json.arrayValue
                print("getArrJson User Profile==",getArrJson)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let allSchool = json["schoolMaster"].arrayValue
                     self.arrSchoolList = allSchool
                     print("arrSchoolList==",self.arrSchoolList)
                     
                 }else{
                    self.displayAlertMessage(messageToDisplay: message)
                 }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
