//
//  CreateNewAssignmentController.swift
//  OpenSIS
//
//  Created by Rejaul on 2/12/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class CreateNewAssignmentController: UIViewController {
    
    
    @IBOutlet weak var textAssignmentName: UITextField!
    
    
    @IBOutlet weak var textTotalPercentage: UITextField!
    
    @IBOutlet weak var viewBack: UIView!
    
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SelectSchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    var stroreCourseSectionID = UserDefaults.standard.string(forKey: "Key_CourseSectionID") ?? ""
    var strorePeriodStartDate = UserDefaults.standard.string(forKey: "Key_PeriodStartDate") ?? ""
    var strorePeriodEndDate = UserDefaults.standard.string(forKey: "Key_PeriodEndDate") ?? ""
    
    var  storeAssignmentTitle = UserDefaults.standard.string(forKey: "Key_AssignmentTitle") ?? ""
    var  storePoints = UserDefaults.standard.string(forKey: "Key_Points") ?? ""
    var  storeAssignmentTypeId = UserDefaults.standard.string(forKey: "Key_AssignmentTypeId") ?? ""
    var  storeAssignmentDate = UserDefaults.standard.string(forKey: "Key_AssignmentDate") ?? ""
    var  storeDueDate = UserDefaults.standard.string(forKey: "Key_DueDate") ?? ""
    var  storeAssignmentDescription = UserDefaults.standard.string(forKey: "Key_AssignmentDescription") ?? ""

    var storeAssignType = UserDefaults.standard.string(forKey: "Key_AssignType") ?? ""
    
    var  storeWeightage = UserDefaults.standard.string(forKey: "Key_Weightage") ?? ""
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("storeAssignType====",storeAssignType)
        
        textTotalPercentage.attributedPlaceholder = NSAttributedString(string: "Present Total", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        
        textAssignmentName.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        textAssignmentName.layer.borderWidth = 0.5
        textAssignmentName.layer.cornerRadius = 3
        
        textTotalPercentage.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        textTotalPercentage.layer.borderWidth = 0.5
        textTotalPercentage.layer.cornerRadius = 3
        
        viewBack.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        viewBack.layer.borderWidth = 1
        viewBack.layer.cornerRadius = 4
        
        
        
        if storeAssignType == "CREATE"{
            textAssignmentName.attributedPlaceholder = NSAttributedString(string: "Title *", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }else{
            textAssignmentName.text = storeAssignmentTitle
            textTotalPercentage.text = storeWeightage
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnTappedCancelTop(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func btnTappedCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnTappedCreateAssign(_ sender: Any) {
        var storeAssignType = UserDefaults.standard.string(forKey: "Key_AssignType") ?? ""
        
        if storeAssignType == "CREATE"{
            callAPICreateAssignment()
        }else{
            callAPIUpdateAssignment()
        }
    }
   
    
    // ====== Create New Assignment
    
    
    func callAPICreateAssignment(){
        
        SVProgressHUD.show()
       let parameters = [
        "assignmentType":[
            "title":textAssignmentName.text!,
            "weightage":textTotalPercentage.text!,
            "courseSectionId":stroreCourseSectionID,
            "markingPeriodId":0,
            "createdBy":"392a89a6-ff74-47c2-ab69-04ae19bcaeb5",
            "schoolId":storeSchoolID,
            "tenantId":storeTenantID
          ],
        "_tenantName":storeTenantName,
        "_userName":storeName,
        "_token":storeToken,
        "tenantId":storeTenantID,
        "schoolId":storeSchoolID,
        "markingPeriodStartDate":"2023-02-01T00:00:00",
        "markingPeriodEndDate":"2023-04-30T00:00:00"
        
       ]as [String : Any];
        print("Param addAssignmentType==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StaffPortalAssignment/addAssignmentType"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("addAssignmentType Response==",response)
                let json = JSON(data)
                print("json addAssignmentType==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let gradeFieldValue = json["gradebookConfiguration"].dictionaryValue
                     print("Grade Feild Value ==",gradeFieldValue)
                     
                     UserDefaults.standard.set("Assignment", forKey: "Key_GradePage")
                     
                     let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
                     let controller = storyBoard.instantiateViewController(withIdentifier: "ClassOverviewNav")
                     self.present(controller, animated: true, completion: nil)
                     
                       
                 }else{
                    self.displayAlertMessage(messageToDisplay: message)
                 }
                DispatchQueue.main.async {
                }
                
                break
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("Request failed with error: \(error)")
                break
            }
            
            
        }
    }
    
    //======= StaffPortalAssignment/updateAssignment
   
    // ====== Update Assignment
    func callAPIUpdateAssignment(){
        
        SVProgressHUD.show()
       let parameters = [
        "assignmentType":[
            "title":textAssignmentName.text!,
            "weightage":textTotalPercentage.text!,
            "assignmentTypeId":storeAssignmentTypeId,
            "courseSectionId":stroreCourseSectionID,
            "markingPeriodId":0,
            "updatedBy":"392a89a6-ff74-47c2-ab69-04ae19bcaeb5",
            "schoolId":storeSchoolID,
            "tenantId":"1e93c7bf-0fae-42bb-9e09-a1cedc8c0355"
            ],
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID
            ]as [String : Any];
        
        
        print("Param Update==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StaffPortalAssignment/updateAssignment"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("update Response==",response)
                let json = JSON(data)
                print("json update==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let gradeFieldValue = json["gradebookConfiguration"].dictionaryValue
                     print("Grade Feild Value ==",gradeFieldValue)
                     
                     let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
                     let controller = storyBoard.instantiateViewController(withIdentifier: "ClassOverviewNav")
                     self.present(controller, animated: true, completion: nil)
                     
                       
                 }else{
                    self.displayAlertMessage(messageToDisplay: message)
                 }
                DispatchQueue.main.async {
                    
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


/* let parameters = [
 "assignment":[
     "assignmentTitle":textAssignmentName.text!,
     "points":"2",
     "assignmentTypeId":9,
     "assignmentDate":"2023-02-13",
     "dueDate":"2023-02-16",
     "assignmentDescription":"",
     "schoolId":storeSchoolID,
     "courseSectionId":stroreCourseSectionID,
     "tenantId":"",
     "staffId":"774",
     "createdBy":"392a89a6-ff74-47c2-ab69-04ae19bcaeb5"
     ],
     "_tenantName":storeTenantName,
     "_userName":storeName,
     "_token":storeToken,
     "tenantId":storeTenantID,
     "schoolId":storeSchoolID
    ]as [String : Any];*/
