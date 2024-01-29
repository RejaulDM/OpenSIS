//
//  GradeController.swift
//  OpenSIS
//
//  Created by Rejaul on 1/30/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON


class GradeController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GradeCell
        
        let item = arrGrade[indexPath.row]
        
        cell.lblAssignmentName.text = item["assignmentTitle"].stringValue
        cell.lblLanguageType.text = item["title"].stringValue
        
        
        let sdate = item["assignmentDate"].stringValue
        let edate = item["dueDate"].stringValue
        let start = sdate.components(separatedBy: "T")
        let getStart : String = start[0]
        let end = edate.components(separatedBy: "T")
        let getEnd : String = end[0]
        
        
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate = inputFormatter.date(from: getStart)
            inputFormatter.dateFormat = "MMM dd, yyyy"
            let resultString = inputFormatter.string(from: showDate!)
        
        let endFormatter = DateFormatter()
        endFormatter.dateFormat = "yyyy-MM-dd"
        let endDate = endFormatter.date(from: getEnd)
        endFormatter.dateFormat = "MMM dd, yyyy"
        let resultStringend = endFormatter.string(from: endDate!)
        
        
        cell.assignDate.text = resultString
        cell.lblDueDate.text = resultStringend
        
        
        //transparents table view cell
            cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = arrGrade[indexPath.row]
        let getassignmentTypeId = item["assignmentTypeId"].stringValue
        print("getassignmentTypeId==",getassignmentTypeId)
        let assintitle = item["assignmentTitle"].stringValue
        UserDefaults.standard.set(getassignmentTypeId, forKey: "Key_AssignmentTypeID")
        
        UserDefaults.standard.set(indexPath.row, forKey: "Key_IndexID")
        
        UserDefaults.standard.set(assintitle, forKey: "Key_AssignTitle")
        
        
        let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "GradeDetailsController")
        self.present(controller, animated: true, completion: nil)
        
    }

}



extension GradeController{
    
    
    // ====== All Grade
    
    func callAPIGetGrade(){
        
        SVProgressHUD.show()
       
        
        let parameters = [
            "courseSectionId": stroreCourseSectionID,
            "SearchValue":"",
            "includeInactive":false,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID,
            "academicYear":storeAcademicYears,
            "_academicYear": storeAcademicYears,
            "markingPeriodStartDate":strorePeriodStartDate,
            "markingPeriodEndDate":strorePeriodEndDate
          ]as [String : Any];
        
        
        print("Param Grade==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StaffPortalGradebook/getGradebookGrade"
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
                print("Grade Response===",response)
                let json = JSON(data)
                print("json Grade==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let StudentForView = json["assignmentsListViewModels"].arrayValue
                     print("Grade View==",StudentForView)
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
