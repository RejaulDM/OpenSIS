//
//  GradeDetailsController.swift
//  OpenSIS
//
//  Created by Rejaul on 1/31/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class GradeDetailsController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var lblAssignNane: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SelectSchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    
    var stroreAssignmentTypeID = UserDefaults.standard.string(forKey: "Key_AssignmentTypeID") ?? ""
    var stroreCourseSectionID = UserDefaults.standard.string(forKey: "Key_CourseSectionID") ?? ""
    var stroreIndexID = UserDefaults.standard.integer(forKey: "Key_IndexID")
    
    var  stroreAssignTitle = UserDefaults.standard.string(forKey: "Key_AssignTitle") ?? ""
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    var arrGrade = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("stroreAssignTitle====",stroreAssignTitle)
        lblAssignNane.text = stroreAssignTitle
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
        self.tableView.tableFooterView = UIView()
        
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        callAPIGetGrade()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBack(_ sender: Any) {
        
        UserDefaults.standard.set("Grade", forKey: "Key_GradePage")
        
        
        let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ClassOverviewNav")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnEdit(_ sender: Any) {
        
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGrade.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GradeDetailsCell
        
        let item = arrGrade[indexPath.row]
        
        let getFname = item["firstGivenName"].stringValue
        let getLname = item["lastFamilyName"].stringValue
        cell.lblName.text = getFname + " " + getLname
        
        
        cell.lblID.text = "ID: " + item["studentInternalId"].stringValue
        cell.textNumber.text = item["allowedMarks"].stringValue
        cell.lblTotalNo.text = " / " + item["points"].stringValue
        
        let comment = item["comment"].stringValue
        if comment == ""{
            cell.textRemarks.attributedPlaceholder = NSAttributedString(string: "Enter Comment", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }else{
            cell.textRemarks.text = comment
        }
        //transparents table view cell
            cell.selectionStyle = .none
        return cell
    }
    

}



extension GradeDetailsController{
    
    
    // ====== All Grade Details
    
    func callAPIGetGrade(){
        
        SVProgressHUD.show()
       //stroreAssignmentTypeID
        //stroreCourseSectionID
        let parameters = [
            "assignmentTpyeId":stroreAssignmentTypeID,
            "courseSectionId":stroreCourseSectionID,
            "SearchValue":"",
            "includeInactive":false,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID,
            "academicYear":storeAcademicYears
           ]as [String : Any];
        
        
        
        print("Param Grade Details==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StaffPortalGradebook/gradebookGradeByAssignmentType"
        print("URL Grade Details==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("Grade Details Response===",response)
                let json = JSON(data)
                print("json Grade Details==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let StudentForView = json["assignmentsListViewModels"].arrayValue
                     print("Grade Details View==",StudentForView)
                     
                     let getAssignDetails = StudentForView[0] //self.stroreIndexID
                     let getAllAssigDetails = getAssignDetails["studentsListViewModels"].arrayValue
                     self.arrGrade = getAllAssigDetails
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
