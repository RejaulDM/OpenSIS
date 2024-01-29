//
//  NotificationMissingAttendanceController.swift
//  OpenSIS
//
//  Created by Rejaul on 7/25/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class NotificationMissingAttendanceController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var lblToDate: UILabel!
    
    @IBOutlet weak var viewStart: UIView!
    
    @IBOutlet weak var viewEnd: UIView!
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var stroreMembershipID = UserDefaults.standard.string(forKey: "Key_MembershipID") ?? ""
    var strorePeriodStartDate = UserDefaults.standard.string(forKey: "Key_PeriodStartDate") ?? ""
    var strorePeriodEndDate = UserDefaults.standard.string(forKey: "Key_PeriodEndDate") ?? ""
    var storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    var arrNotificationList = [JSON]()
    
    var selectDateRange = ""
    let datePicker = DatePickerDialog()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewStart.layer.cornerRadius = 8
        viewStart.layer.borderWidth = 1
        viewStart.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        viewEnd.layer.cornerRadius = 8
        viewEnd.layer.borderWidth = 1
        viewEnd.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView()
        
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        //show date in label fields
        let date = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MMM dd, yyyy"
        let currentDate = formatter1.string(from: date)
        lblToDate.text = currentDate
        
        
        callAPIGetNotificationList()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func lblBack(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardNav")
        self.present(controller, animated: true, completion: nil)
    }
  
    
    @IBAction func btnTapChooseFromDate(_ sender: Any) {
        print("tap working")
     
     selectDateRange = "fromDate"
     datePickerTapped()
     
        
    }

    @IBAction func btnTapChooseToDate(_ sender: Any) {
        print("tap working")
        
        datePickerTapped()
        selectDateRange = "toDate"
       
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! NotificationMissingAttendanceCell
        
        let item = arrNotificationList[indexPath.row]
        cell.lblNotoficationName.text = item["courseSectionName"].stringValue
        cell.lblGrade.text = item["courseTitle"].stringValue
        cell.lblRoom.text = item["periodTitle"].stringValue
        cell.lblRoomGrade.text = item["courseGradeLevel"].stringValue
        //2023-05-08T00:00:00
        let eventSDate1 = item["attendanceDate"].stringValue
        let start = eventSDate1.components(separatedBy: "T")
        let getStart : String = start[0]
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let showDate = inputFormatter.date(from: getStart)
        inputFormatter.dateFormat = "MMM dd, yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        cell.lblDate.text = resultString
       
        cell.ClickCellDelegate = self
        cell.indexID = indexPath
        
        //transparents table view cell
            cell.selectionStyle = .none
        return cell
    }
    
    
    func callAPIGetNotificationList(){
        
        SVProgressHUD.show()
        
        let parameters = [
            "_failure":false,
                "_message":"",
                "staffId":storeUserID,
                "schoolId":storeSchoolID,
                "_tenantName":storeTenantName,
                "_userName":storeName,
                "_token":storeToken,
                "tenantId":storeTenantID,
                "_academicYear": storeAcademicYears,
                "academicYear":storeAcademicYears
            ] as [String : Any];
        
        
        print("Param Notification==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StaffPortal/getAllMissingAttendanceListForStaff"
        print("URL All Notification==",urlString)
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
                print("json All Notification==",json)
                let getArrJson = json.arrayValue
                print("getArrJson All Notification==",getArrJson)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let allSchool = json["courseSectionViewList"].arrayValue
                     self.arrNotificationList = allSchool
                     
                     if allSchool.count == 0{}else{
                         let getFirstObj = allSchool[0]
                         let eventSDate1 = getFirstObj["attendanceDate"].stringValue
                         let start = eventSDate1.components(separatedBy: "T")
                         let getStart : String = start[0]
                         
                         let inputFormatter = DateFormatter()
                         inputFormatter.dateFormat = "yyyy-MM-dd"
                         let showDate = inputFormatter.date(from: getStart)
                         inputFormatter.dateFormat = "MMM dd, yyyy"
                         let resultString = inputFormatter.string(from: showDate!)
                         self.lblFromDate.text = resultString
                     }
                     print("arr All Notification List==",self.arrNotificationList)
                     
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

extension NotificationMissingAttendanceController:TakeAttendance {
    func ClickCellID(index: Int) {
        print("\(index) Tapped Mail==")
        
        let item = arrNotificationList[index]
        let eventSDate1 = item["attendanceDate"].stringValue
        let start = eventSDate1.components(separatedBy: "T")
        let getStart : String = start[0]
        print("\(getStart) Attendance Date==")
        UserDefaults.standard.set(getStart, forKey: "Key_AttDate")
        let courseSectionName = item["courseSectionName"].stringValue
        UserDefaults.standard.set(courseSectionName, forKey: "Key_CourseSectionName")
        
        let courseId = item["courseId"].stringValue
        UserDefaults.standard.set(courseId, forKey: "Key_CourseId")
        
        let courseSectionId = item["courseSectionId"].stringValue
        UserDefaults.standard.set(courseSectionId, forKey: "Key_AttCourseSectionId")
        
        courseSectionId
        
        let periodId = item["periodId"].stringValue
        UserDefaults.standard.set(periodId, forKey: "Key_PeriodId")
        
        let attendanceCategoryId = item["attendanceCategoryId"].stringValue
        UserDefaults.standard.set(attendanceCategoryId, forKey: "Key_AttCategoryId")
        
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "MissingAttendanceListController")
        self.present(controller, animated: true, completion: nil)
        
    }
    
}

extension NotificationMissingAttendanceController{
    
    // ======= Date Picker Dialog
    
    func datePickerTapped() {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, yyyy"
                
                if (self.selectDateRange.elementsEqual("fromDate")){
                    
                    self.lblFromDate.text = formatter.string(from: dt)
                    
                }else{
                    self.lblToDate.text = formatter.string(from: dt)
                }
                
            }
        }
    }
}
