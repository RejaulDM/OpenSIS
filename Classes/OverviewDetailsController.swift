//
//  OverviewDetailsController.swift
//  OpenSIS
//
//  Created by Rejaul on 1/18/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import Toast_Swift

class OverviewDetailsController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewOverview: UIView!
    @IBOutlet weak var lblCourseSectionName: UILabel!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblSubject: UILabel!    
    @IBOutlet weak var lblCalendar: UILabel!
    @IBOutlet weak var lblGradeScale: UILabel!
    @IBOutlet weak var lblCreditHours: UILabel!
    @IBOutlet weak var lblTotalSeat: UILabel!
    @IBOutlet weak var lblAvailableSeat: UILabel!
    @IBOutlet weak var lblAttendanceCategory: UILabel!
    
    @IBOutlet weak var lblCourseWeighted: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var lblUseStandards: UILabel!
    @IBOutlet weak var imgUseStandards: UIImageView!
    
    @IBOutlet weak var lblAffectsClassRank: UILabel!
    @IBOutlet weak var imgAffectsClassRank: UIImageView!
    
    @IBOutlet weak var lblAffectsHonorRoll: UILabel!
    @IBOutlet weak var imgAffectsHonorRoll: UIImageView!
    
    @IBOutlet weak var lblOnlineClassroom: UILabel!
    @IBOutlet weak var imgOnlineClassroom: UIImageView!
    
    @IBOutlet weak var lblStandardGradeScale: UILabel!
    
    @IBOutlet weak var lblOnlineClassroomURL: UITextField!
    
    
    @IBOutlet weak var lblOnlineClassroomPassword: UITextField!
    
    @IBOutlet weak var lblMarkingPeriod: UILabel!
    
    
    @IBOutlet weak var lblScheduleType: UILabel!
    @IBOutlet weak var lblRoom: UILabel!
    @IBOutlet weak var lblPeriod: UILabel!
    
    
    @IBOutlet weak var btnSun: UIButton!
    @IBOutlet weak var btnMon: UIButton!
    @IBOutlet weak var btnTue: UIButton!
    @IBOutlet weak var btnWed: UIButton!
    
    @IBOutlet weak var btnThu: UIButton!
    
    @IBOutlet weak var btnFri: UIButton!
    
    @IBOutlet weak var btnSatu: UIButton!
    
    @IBOutlet weak var viewDayTime: UIView!
    @IBOutlet weak var viewScheduleType: UIView!
    
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
    
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var stroreMembershipID = UserDefaults.standard.string(forKey: "Key_MembershipID") ?? ""
    var storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    var storeCourseSectionID = UserDefaults.standard.string(forKey: "Key_CourseSectionID") ?? ""
    
    var storeCourseID = UserDefaults.standard.string(forKey: "Key_CourseID") ?? ""
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    let btnBackImg = UIImage(named: "colorbox") as UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblOnlineClassroomURL.delegate = self
        
         viewOverview.layer.cornerRadius = 10
         viewOverview.layer.borderWidth = 1
         viewOverview.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
         
         viewDayTime.layer.cornerRadius = 10
         viewDayTime.layer.borderWidth = 1
         viewDayTime.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
         
         viewScheduleType.layer.cornerRadius = 10
         viewScheduleType.layer.borderWidth = 1
         viewScheduleType.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        callAPIOverviewSetails()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnTappedTextEdite(_ sender: Any) {
        lblOnlineClassroomURL.isEnabled = true
        lblOnlineClassroomURL.endEditing(true)
        lblOnlineClassroomURL.becomeFirstResponder()
    }
    
    @IBAction func btnCoyPass(_ sender: Any) {
        UIPasteboard.general.string = lblOnlineClassroomPassword.text
        
        self.view.makeToast("Password copied successfully", duration: 2.0, position: .bottom)
    }
    
}


extension OverviewDetailsController{
    
    
    // ====== All Schoils Lists
    
    func callAPIOverviewSetails(){
        
        SVProgressHUD.show()
        let parameters = [
            "courseId": storeCourseID,
            "academicYear":storeAcademicYears,
            "schoolId": storeSchoolID,
            "tenantId":storeTenantID,
            "_tenantName":storeTenantName,
            "_token":storeToken,
            "_userName":storeName
            ] as [String : Any];
        print("Param overview Details==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "CourseManager/getAllCourseSection"
        print("URL MyClasses==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                let json = JSON(data)
                print("json Overview==",json)
                let getArrJson = json.arrayValue
                print("getArrJson Overview==",getArrJson)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let allSections = json["getCourseSectionForView"].arrayValue
                     print("allSections===",allSections)
                     
                     for val in allSections {
                         
                         let courseSection = val["courseSection"].dictionaryValue
                         let sectionId = courseSection["courseSectionId"]?.stringValue
                         print("sectionId===",sectionId)
                         
                         print("storeCourseSectionID=",self.storeCourseSectionID)
                         
                         if self.storeCourseSectionID == sectionId{
                             
                             let availableSeat = val["availableSeat"].stringValue
                             let standardGradeScaleName = val["standardGradeScaleName"].stringValue
                             
                             let coursename = courseSection["courseSectionName"]?.stringValue
                             print("coursename overview Details==",coursename)
                             
                             let course = courseSection["course"]?.dictionaryValue
                             let schoolCalendars = courseSection["schoolCalendars"]?.dictionaryValue
                             let attendanceCategories = courseSection["attendanceCodeCategories"]?.dictionaryValue
                             
                             self.lblCourseSectionName.text = courseSection["courseSectionName"]?.stringValue
                             
                             self.lblCourse.text = course?["courseTitle"]?.stringValue
                             self.lblSubject.text = course?["courseSubject"]?.stringValue
                             self.lblCalendar.text = schoolCalendars?["title"]?.stringValue
                             self.lblCreditHours.text = courseSection["creditHours"]?.stringValue
                             self.lblTotalSeat.text = (courseSection["seats"]?.stringValue ?? " ") + "|"
                             self.lblAvailableSeat.text =  availableSeat + " Available"
                             self.lblAttendanceCategory.text = attendanceCategories?["title"]?.stringValue
                             self.lblStandardGradeScale.text = standardGradeScaleName
                             self.lblOnlineClassroomURL.text = courseSection["onlineClassroomUrl"]?.stringValue
                             self.lblOnlineClassroomPassword.text = courseSection["onlineClassroomPassword"]?.stringValue
                             
                             let sdate = courseSection["durationStartDate"]?.stringValue
                             let edate = courseSection["durationEndDate"]?.stringValue
                             let start = sdate?.components(separatedBy: "T")
                             let getStart : String = start?[0] ?? " "
                             let end = edate?.components(separatedBy: "T")
                             let getEnd : String = end?[0] ?? " "
                             
                             
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
                             
                             self.lblMarkingPeriod.text = resultString + " To " + resultStringend
                             
                             let courseFSchedule = val["courseFixedSchedule"].dictionaryValue
                             let blockPeriod = courseFSchedule["blockPeriod"]?.dictionaryValue
                             let periodTitle = blockPeriod?["periodTitle"]?.stringValue
                             let periodStartTime = blockPeriod?["periodStartTime"]?.stringValue
                             
                             let rooms = courseFSchedule["rooms"]?.dictionaryValue
                             let titleroom = rooms?["title"]?.stringValue
                             
                             self.lblRoom.text = titleroom
                             self.lblPeriod.text = periodTitle
                             
                             
                             let showday = courseSection["meetingDays"]?.stringValue
                             let dayList = showday!.components(separatedBy: "|")
                             print("Show DayList===",dayList)
                             
                             for val in dayList
                             {
                                 switch(val){
                                 case "Monday":
                                     self.btnMon.setBackgroundImage(self.btnBackImg, for:.normal)
                                     self.btnMon.setTitleColor(.white, for: .normal)
                                     break;
                                 case "Tuesday":
                                     self.btnTue.setBackgroundImage(self.btnBackImg, for:.normal)
                                     self.btnTue.setTitleColor(.white, for: .normal)
                                     break;
                                 case "Wednesday":
                                     self.btnWed.setBackgroundImage(self.btnBackImg, for:.normal)
                                     self.btnWed.setTitleColor(.white, for: .normal)
                                     break;
                                 case "Thursday":
                                     self.btnThu.setBackgroundImage(self.btnBackImg, for:.normal)
                                     self.btnThu.setTitleColor(.white, for: .normal)
                                     break;
                                 case "Friday":
                                     self.btnFri.setBackgroundImage(self.btnBackImg, for:.normal)
                                     self.btnFri.setTitleColor(.white, for: .normal)
                                     break;
                                 case "Saturday":
                                     self.btnSatu.setBackgroundImage(self.btnBackImg, for:.normal)
                                     self.btnSatu.setTitleColor(.white, for: .normal)
                                     break;
                                 default:
                                     break;
                                     
                                 }
                             }
                             
                             
                         }
                         
                     }
                     
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
