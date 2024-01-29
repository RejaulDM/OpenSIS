//
//  PercentGradeController.swift
//  OpenSIS
//
//  Created by Rejaul on 5/17/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class PercentGradeController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SelectSchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    
    var strorePeriodStartDate = UserDefaults.standard.string(forKey: "Key_PeriodStartDate") ?? ""
    var strorePeriodEndDate = UserDefaults.standard.string(forKey: "Key_PeriodEndDate") ?? ""
    
    var stroreCourseSectionID = UserDefaults.standard.string(forKey: "Key_CourseSectionID") ?? ""
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    var arrGrade = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
        self.tableView.tableFooterView = UIView()
        
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        callAPIGetGrade()

        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGrade.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PercentGradeCell
        
        let item = arrGrade[indexPath.row]
        
        let FName = item["firstGivenName"].stringValue
        let LName = item["lastFamilyName"].stringValue
        cell.lblName.text = FName + " " + LName
        cell.lblGrade.text = item["gradeLevel"].stringValue
        
        
        //transparents table view cell
            cell.selectionStyle = .none
        return cell
    }
    
   

}


extension PercentGradeController{
    
    
    // ====== All Grade
    
    func callAPIGetGrade(){
        var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
        SVProgressHUD.show()
       
        
        let parameters = [
            "pageNumber":1,
            "_pageSize":10,
            "sortingModel":"",
            "filterParams":[],
            "courseSectionIds":[stroreCourseSectionID],
            "profilePhoto":true,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId": storeSchoolID
          ]as [String : Any];
        
        print("Param Grade Latter==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StudentSchedule/getStudentListByCourseSection"
        print("URL Student==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                //print("Grade Latter Response===",response)
                let json = JSON(data)
                print("json Latter Grade==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let StudentForView = json["scheduleStudentForView"].arrayValue
                     print("Grade Latter View==",StudentForView)
                     self.arrGrade = StudentForView
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
