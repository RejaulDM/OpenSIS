//
//  AttendanceMarkPopup.swift
//  OpenSIS
//
//  Created by Rejaul on 1/24/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class AttendanceMarkPopup: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mainBackView: UIView!
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var storeCourseSectionID = UserDefaults.standard.string(forKey: "Key_CourseSectionID") ?? ""
    var storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    var arrAttendanceList = [JSON]()
    
    var arrAttendanceStatus = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainBackView.layer.borderColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        mainBackView.layer.borderWidth = 1
        mainBackView.layer.cornerRadius = 8
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
        self.tableView.tableFooterView = UIView()
        
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        tableView.reloadData()
        
        callAPIGetAttendanceList()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnCancell(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAttendanceStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendanceMarkPopupCell
        
        let item = arrAttendanceStatus[indexPath.row]
        
        cell.lblAttStatus.text = item["stateCode"].stringValue + "(" + item["shortName"].stringValue + ")"
        let attstsud = item["shortName"].stringValue
        
        if attstsud == "P"{
            cell.viewBack.layer.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }else if attstsud == "Ab"{
            cell.viewBack.layer.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }else if attstsud == "HF"{
            cell.viewBack.layer.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        }
        
        //transparents table view cell
            cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = arrAttendanceStatus[indexPath.row]
        let attstsud = item["shortName"].stringValue
        
        UserDefaults.standard.set(attstsud, forKey: "Key_AttendanceStatus")
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
}



extension AttendanceMarkPopup{
    
    // ====== All Student Att Lists
    
    func callAPIGetAttendanceList(){
        SVProgressHUD.show()
        
       
        
        let parameters = [
            "attendanceCodeList": [],
            "attendanceCategoryId":1,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID,
            "academicYear":storeAcademicYears
            
            ] as [String : Any];
        print("Param Attendance Status==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "AttendanceCode/getAllAttendanceCode"
        print("URL Attendance==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("att Status===",response)
                let json = JSON(data)
                print("json Attendance Status==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let allSchool = json["attendanceCodeList"].arrayValue
                     self.arrAttendanceStatus = allSchool
                     print("arrAttendanceStatus==",self.arrAttendanceStatus)
                     
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
    
    
    // ====== All Att Code
    
    func callAPIGetAttendanceCode(){
        SVProgressHUD.show()
        
        let parameters = [
            "pageNumber":1,
            "_pageSize":10,
            "sortingModel":"",
            "filterParams":[],
            "courseSectionIds":[storeCourseSectionID],
            "includeInactive":false,
            "profilePhoto":true,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID
            ] as [String : Any];
        print("Param Attendance Code==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "AttendanceCode/getAllAttendanceCode"
        print("URL Attendance Code==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("StudentResponse Code===",response)
                let json = JSON(data)
                print("json Attendance Code==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let allSchool = json["scheduleStudentForView"].arrayValue
                     
                     print("arrAttendanceList==",self.arrAttendanceList)
                     
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
