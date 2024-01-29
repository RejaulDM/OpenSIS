//
//  CreateNewInsideAssignmentController.swift
//  OpenSIS
//
//  Created by Rejaul on 2/17/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON


class CreateNewInsideAssignmentController: UIViewController {

    
    @IBOutlet weak var textAssignTitle: UITextField!
    
    @IBOutlet weak var textPoints: UITextField!
    
    
    @IBOutlet weak var textAssignDate: UITextField!
    
    
    @IBOutlet weak var textDueDate: UITextField!
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
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
    
    var selectDateRange = ""
    let datePicker = DatePickerDialog()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("storeSchoolID==",storeSchoolID)
        
        //clickable label code
        let tapRe = UITapGestureRecognizer(target: self, action: #selector(CreateNewInsideAssignmentController.tappRe))
        textAssignDate.isUserInteractionEnabled = true
        textAssignDate.addGestureRecognizer(tapRe)
        
        //clickable label code
        let tapRe1 = UITapGestureRecognizer(target: self, action: #selector(CreateNewInsideAssignmentController.tappRe1))
        textDueDate.isUserInteractionEnabled = true
        textDueDate.addGestureRecognizer(tapRe1)

        // Do any additional setup after loading the view.
    }
    
    
    @objc func tappRe(sender: UITapGestureRecognizer) {
        print("tap working")
        
        selectDateRange = "fromDate"
        datePickerTapped()
        
    }
    
    @objc func tappRe1(sender: UITapGestureRecognizer) {
        print("tap working")
        
        datePickerTapped()
        selectDateRange = "toDate"
        
    }
    
    
    // ======= Date Picker Dialog
    
    func datePickerTapped() {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                
                if (self.selectDateRange.elementsEqual("fromDate")){
                    
                    self.textAssignDate.text = formatter.string(from: dt)
                    
                }else{
                    self.textDueDate.text = formatter.string(from: dt)
                }
                
            }
        }
    }
    

    
    @IBAction func btnCancel(_ sender: Any) {
        
    self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnCancel1(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnTappedSubmite(_ sender: Any) {
        callAPICreateAssignment()
    }
    
    
    
    // ====== Create New Assignment
    
    
    func callAPICreateAssignment(){
        
        SVProgressHUD.show()
        let parameters = [
         "assignment":[
             "assignmentTitle":textAssignTitle.text!,
             "points":textPoints.text!,
             "assignmentTypeId":storeAssignmentTypeId,
             "assignmentDate":textAssignDate.text!,
             "dueDate":textDueDate.text!,
             "assignmentDescription":"",
             "schoolId":storeSchoolID,
             "courseSectionId":stroreCourseSectionID,
             "tenantId":storeTenantID,
             "staffId":storeUserID,
             "createdBy":"392a89a6-ff74-47c2-ab69-04ae19bcaeb5"
             ],
             "_tenantName":storeTenantName,
             "_userName":storeName,
             "_token":storeToken,
             "tenantId":storeTenantID,
            "_academicYear":storeAcademicYears,
             "schoolId":storeSchoolID
            ]as [String : Any];
        print("Param addAssignmentType==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StaffPortalAssignment/addAssignment"
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
                     
                     
                     
                     let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
                     let controller = storyBoard.instantiateViewController(withIdentifier: "InsideAssignmentCreateController")
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
