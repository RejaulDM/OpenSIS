//
//  GradeBookConfiguarionController.swift
//  OpenSIS
//
//  Created by Rejaul on 2/7/23.
//

import UIKit

import SVProgressHUD
import Alamofire
import SwiftyJSON
import SearchTextField
import DTTextField
class GradeBookConfiguarionController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var viewGeneral: UIView!
    
    @IBOutlet weak var btnActionWeight: UIButton!
    @IBOutlet weak var btnActionAssigned: UIButton!
    @IBOutlet weak var btnActionDueDate: UIButton!
    @IBOutlet weak var btnActionUp: UIButton!
    @IBOutlet weak var btnActionDown: UIButton!
    @IBOutlet weak var btnActionNormal: UIButton!
    @IBOutlet weak var btnActionNone: UIButton!
    @IBOutlet weak var btnActionNewest: UIButton!
    @IBOutlet weak var btnActionAssignmentDueDate: UIButton!
    @IBOutlet weak var btnActionAssignDate: UIButton!
    @IBOutlet weak var btnActionUngrade: UIButton!
    @IBOutlet weak var textPresent: DTTextField!
    
    @IBOutlet weak var textDays: DTTextField!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
   // var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SelectSchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    var stroreCourseSectionID = UserDefaults.standard.string(forKey: "Key_CourseSectionID") ?? ""
    var  stroreCourseID = UserDefaults.standard.string(forKey: "Key_CourseID") ?? ""
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
    
    let checkImg = UIImage(named: "checkbox_checked") as UIImage?
    let uncheckImg = UIImage(named: "checkbox") as UIImage?
    
    let checkImgR = UIImage(named: "radio_button_checked") as UIImage?
    let uncheckImgR = UIImage(named: "radio_button") as UIImage?
    
    var gradeBookFieldName = [SelectedGradeBookField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        textPresent.layer.borderWidth = 0.5
        textPresent.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        textDays.layer.borderWidth = 0.5
        textDays.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        textPresent.attributedPlaceholder = NSAttributedString(string: "Present", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        textDays.attributedPlaceholder = NSAttributedString(string: "Days", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
        self.tableView.tableFooterView = UIView()
        
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        //callAPIGetGradeConfiguFiealdName()
        callAPIGetGradeBookFieldValue()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
     
        
    }
    
    
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        let CELL_INDEXID = UserDefaults.standard.string(forKey: "CELL_INDEXID")
        print("CELL_INDEXID======",CELL_INDEXID!)
        let getIndexID: Int? = Int(CELL_INDEXID!)
        
        let cellText = UserDefaults.standard.string(forKey: "CELL_Text") ?? ""
        print("cellText======",cellText)
        let GetRemar = UserDefaults.standard.string(forKey: "GetRemarks") ?? ""
        print("GetRemar======",GetRemar)
        
        if cellText == "EnterText1"{
            
            let dict = gradeBookFieldName[getIndexID!]
            let Title = dict.Title!
            let MarkingPeriodId = dict.MarkingPeriodId!
            let SemesterId = dict.SemesterId!
            let Quater1 = GetRemar
            let Quater1Exm = dict.Quater1Exm!
            let tenantId = dict.tenantId!
            let schoolId = dict.schoolId!
            let courseId = dict.courseId!
            let courseSectionId = dict.courseSectionId!
            let academicYear = dict.academicYear!
            let smstrMarkingPeriodId = dict.smstrMarkingPeriodId!
            let createdBy = dict.createdBy!
            let createdOn = dict.createdOn!
            let updatedBy = dict.updatedBy!
            let updatedOn = dict.updatedOn!
            
            gradeBookFieldName.remove(at: getIndexID!)
            gradeBookFieldName.insert(SelectedGradeBookField(Title: Title,MarkingPeriodId: MarkingPeriodId,SemesterId: SemesterId,Quater1: Quater1,Quater1Exm: Quater1Exm,tenantId: tenantId,schoolId: schoolId,courseId: courseId,courseSectionId: courseSectionId,academicYear: academicYear,smstrMarkingPeriodId: smstrMarkingPeriodId,createdBy: createdBy,createdOn: createdOn,updatedBy: updatedBy,updatedOn: updatedOn), at: getIndexID!)
        }else{
            
            let dict = gradeBookFieldName[getIndexID!]
            let Title = dict.Title!
            let MarkingPeriodId = dict.MarkingPeriodId!
            let SemesterId = dict.SemesterId!
            let Quater1 = dict.Quater1!
            let Quater1Exm = GetRemar
            let tenantId = dict.tenantId!
            let schoolId = dict.schoolId!
            let courseId = dict.courseId!
            let courseSectionId = dict.courseSectionId!
            let academicYear = dict.academicYear!
            let smstrMarkingPeriodId = dict.smstrMarkingPeriodId!
            let createdBy = dict.createdBy!
            let createdOn = dict.createdOn!
            let updatedBy = dict.updatedBy!
            let updatedOn = dict.updatedOn!
            
            gradeBookFieldName.remove(at: getIndexID!)
            gradeBookFieldName.insert(SelectedGradeBookField(Title: Title,MarkingPeriodId: MarkingPeriodId,SemesterId: SemesterId,Quater1: Quater1,Quater1Exm: Quater1Exm,tenantId: tenantId,schoolId: schoolId,courseId: courseId,courseSectionId: courseSectionId,academicYear: academicYear,smstrMarkingPeriodId: smstrMarkingPeriodId,createdBy: createdBy,createdOn: createdOn,updatedBy: updatedBy,updatedOn: updatedOn), at: getIndexID!)
        }
        
        tableView.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gradeBookFieldName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuarterGradeBookCell
        
        let item = gradeBookFieldName[indexPath.row]
        
        cell.lblQuaterName.text = item.Title
        cell.textQuater1.text = item.Quater1
        cell.textQuater1Exam.text = item.Quater1Exm
        
        cell.ClickCellDelegate1 = self
        cell.indexID1 = indexPath
        
        cell.ClickCellDelegate2 = self
        cell.indexID2 = indexPath
        
        //transparents table view cell
            cell.selectionStyle = .none
        return cell
    }
    

    @IBAction func btnTappedSubmite(_ sender: Any) {
        
    }
    
}

extension GradeBookConfiguarionController: BtnUserText1 {
    func ClickCellID1(index: Int) {
        print("\(index) is clicked===== ")
        //tappedIndex = index
            UserDefaults.standard.set(index, forKey: "CELL_INDEXID")
        UserDefaults.standard.set("EnterText1", forKey: "CELL_Text")
        
        let vc = QuaterGradeBookInputController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        

        
    }
    
}


extension GradeBookConfiguarionController: BtnUserText2 {
    func ClickCellID2(index: Int) {
        print("\(index) is clicked===== ")
        //tappedIndex = index
            UserDefaults.standard.set(index, forKey: "CELL_INDEXID")
            
        UserDefaults.standard.set("EnterText2", forKey: "CELL_Text")
        let vc = QuaterGradeBookInputController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        

        
    }
    
}



extension GradeBookConfiguarionController{
   // ====== All Grade Configuration
    
    func callAPIGetGradeConfiguFiealdName(){
        
        SVProgressHUD.show()
       //stroreAssignmentTypeID
        //stroreCourseSectionID
        let parameters = [
            "courseSectionId":stroreCourseSectionID,
            "isConfiguration":true,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID,
            "academicYear":storeAcademicYears
           ]as [String : Any];
        
        print("Param Grade Fields==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StaffPortalGradebook/populateFinalGrading"
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
                print("Grade Fields Response==",response)
                let json = JSON(data)
                print("json Grade Fields==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let gradeQuater = json["quarters"].arrayValue
                     print("Grade quarters ==",gradeQuater)
                     
                     for val in gradeQuater{
                         let title = val["title"].stringValue
                         let markingPeriodId = val["markingPeriodId"].stringValue
                         let semesterId = val["semesterId"].stringValue
                         
                         self.gradeBookFieldName.append(SelectedGradeBookField(Title: String() + title, MarkingPeriodId: String() + markingPeriodId, SemesterId: String() + semesterId, Quater1: String() + "0", Quater1Exm: String() + "0", tenantId: String() + self.storeTenantID, schoolId: String() + self.storeSchoolID, courseId: String() + self.stroreCourseID, courseSectionId: String() + self.stroreCourseSectionID, academicYear: String() + self.storeAcademicYears, smstrMarkingPeriodId: String() + "0", createdBy: String() + "392a89a6-ff74-47c2-ab69-04ae19bcaeb5", createdOn: String() + "2022-12-20T13:24:46", updatedBy: String() + "392a89a6-ff74-47c2-ab69-04ae19bcaeb5", updatedOn: String() + "2022-12-20T13:24:46"))
                         
                     }
                       
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
    
    // ====== Get Grade Book Fields Value Details
    
    
    func callAPIGetGradeBookFieldValue(){
        
        SVProgressHUD.show()
       let parameters = [
        
            "gradebookConfiguration":[
                "scoreRounding":"up",
                "assignmentSorting":"newestFirst",
                "gradebookConfigurationProgressPeriods":[],
                "gradebookConfigurationQuarter":[],
                "gradebookConfigurationSemester":[],
                "gradebookConfigurationYear":[],
                "lmsGradeSync": 1,
                "general":"",
                "courseId":stroreCourseID,
                "courseSectionId":stroreCourseSectionID,
                "academicYear":storeAcademicYears,
                "schoolId":storeSchoolID,
                "tenantId":storeTenantID
              ],
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "_academicYear": storeAcademicYears,
            "schoolId":storeSchoolID
    ]as [String : Any];
        
       
        
        print("Param Grade Fields Value==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StaffPortalGradebook/viewGradebookConfiguration"
        print("URL Grade Details value==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("Grade Fields Value Response==",response)
                let json = JSON(data)
                print("json Grade Fields Value==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let gradeFieldValue = json["gradebookConfiguration"].dictionaryValue
                     print("Grade Feild Value ==",gradeFieldValue)
                     
                     let general = gradeFieldValue["general"]?.stringValue
                     
                     let dayList = general!.components(separatedBy: "|")
                     print("General Selected List===",dayList)
                     
                     for val in dayList
                     {
                         switch(val){
                         case "weightGrades":
                             self.btnActionWeight.setBackgroundImage(self.checkImg, for: .normal)
                             break;
                         case "assignedDateDefaultsToToday":
                             self.btnActionAssigned.setBackgroundImage(self.checkImg, for: .normal)
                             break;
                         case "dueDateDefaultsToToday":
                             self.btnActionDueDate.setBackgroundImage(self.checkImg, for: .normal)
                             break;
                         default:
                             break;
                             
                         }
                     }
                     
                     let  scoreRounding = gradeFieldValue["scoreRounding"]?.stringValue
                     
                     if scoreRounding == "up"{
                        self.btnActionUp.setBackgroundImage(self.checkImgR, for: .normal)
                     }else if scoreRounding == "down"{
                         self.btnActionDown.setBackgroundImage(self.checkImgR, for: .normal)
                     }else if scoreRounding == "normal"{
                         self.btnActionNormal.setBackgroundImage(self.checkImgR, for: .normal)
                     }else if scoreRounding == "none"{
                         self.btnActionNone.setBackgroundImage(self.checkImgR, for: .normal)
                     }
                     
                     let assignmentSorting = gradeFieldValue["assignmentSorting"]?.stringValue
                     
                     if assignmentSorting == "newestFirst"{
                         self.btnActionNewest.setBackgroundImage(self.checkImgR, for: .normal)
                     }else if assignmentSorting == "dueDate"{
                         self.btnActionAssignmentDueDate.setBackgroundImage(self.checkImgR, for: .normal)
                     }else if assignmentSorting == "assignedDate"{
                         self.btnActionAssignDate.setBackgroundImage(self.checkImgR, for: .normal)
                     }else if assignmentSorting == "ungraded"{
                         self.btnActionUngrade.setBackgroundImage(self.checkImgR, for: .normal)
                     }
                   
                     
                     let  maxAnomalousGrade = gradeFieldValue["maxAnomalousGrade"]?.stringValue
                     self.textPresent.text = maxAnomalousGrade
                     
                     let  upgradedAssignmentGradeDays = gradeFieldValue["upgradedAssignmentGradeDays"]?.stringValue
                     self.textDays.text = upgradedAssignmentGradeDays
                     
                     
                     let getSamesterVal = gradeFieldValue["gradebookConfigurationQuarter"]?.arrayValue
                     
                     for val in getSamesterVal!{
                         let title = val["title"].stringValue
                         let markingPeriodId = val["markingPeriodId"].stringValue
                         let semesterId = val["semesterId"].stringValue
                         let gradingPercentage = val["gradingPercentage"].stringValue
                         let examPercentage = val["examPercentage"].stringValue
                         
                         
                         self.gradeBookFieldName.append(SelectedGradeBookField(Title: String() + title, MarkingPeriodId: String() + markingPeriodId, SemesterId: String() + semesterId, Quater1: String() + gradingPercentage, Quater1Exm: String() + examPercentage, tenantId: String() + self.storeTenantID, schoolId: String() + self.storeSchoolID, courseId: String() + self.stroreCourseID, courseSectionId: String() + self.stroreCourseSectionID, academicYear: String() + self.storeAcademicYears, smstrMarkingPeriodId: String() + "0", createdBy: String() + "392a89a6-ff74-47c2-ab69-04ae19bcaeb5", createdOn: String() + "2022-12-20T13:24:46", updatedBy: String() + "392a89a6-ff74-47c2-ab69-04ae19bcaeb5", updatedOn: String() + "2022-12-20T13:24:46"))
                         
                         
                         
                         
                         
                     }
                       
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


class SelectedGradeBookField {
    
    var Title:String?
    var MarkingPeriodId:String?
    var SemesterId:String?
    var Quater1:String?
    var Quater1Exm:String?
    var tenantId:String?
    var schoolId:String?
    var courseId:String?
    var courseSectionId:String?
    var academicYear:String?
    var smstrMarkingPeriodId:String?
    var createdBy:String?
    var createdOn:String?
    var updatedBy:String?
    var updatedOn:String?
    
    init(Title: String?, MarkingPeriodId: String?, SemesterId: String?,Quater1:String?,Quater1Exm:String,tenantId:String   ,schoolId:String,courseId:String,courseSectionId:String,academicYear:String,smstrMarkingPeriodId:String,createdBy:String,createdOn:String,updatedBy:String,updatedOn:String) {
        
        self.Title = Title
        self.MarkingPeriodId = MarkingPeriodId
        self.SemesterId = SemesterId
        self.Quater1 = Quater1
        self.Quater1Exm = Quater1Exm
        self.tenantId = tenantId
        self.schoolId = schoolId
        self.courseId = courseId
        self.courseSectionId = courseSectionId
        self.academicYear = academicYear
        self.smstrMarkingPeriodId = Quater1Exm
        self.createdBy = createdBy
        self.createdOn = createdOn
        self.updatedBy = updatedBy
        self.updatedOn = updatedOn
        
        
    }
}



