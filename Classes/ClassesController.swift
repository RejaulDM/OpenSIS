//
//  ClassesController.swift
//  OpenSIS
//
//  Created by Rejaul on 11/30/22.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON



class ClassesController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
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
    
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    let storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    
    var arrMyClassesList = [JSON]()
    
    var arrViewCourseList = [JSON]()
    
    var selectedCourseList = [SelectedCourseList]()
    
    var textVSchedule = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
        self.tableView.tableFooterView = UIView()
        
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        callAPIGetLassesList()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func btnTappedHome(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardNav")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func btnTappedSchedule(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Schedule", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ScheduleController")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCourseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ClassesCell
        
        let item = selectedCourseList[indexPath.row]
            
        cell.lblCourseName.text = item.CourseSectionName
        cell.lblCourseType.text = item.CourseTitle
        cell.lblGrade.text = item.CourseGradeLevel
        cell.lblRoomCode.text = item.RoomTitle
        cell.lblPeriod.text = item.PeriodTitle
        cell.lblTime.text = item.PeriodStartTime
        
        let ScheduleType = item.ScheduleType
        
        if ScheduleType == "Variable Schedule"{
            cell.lblVSheduleText.text = item.ScheduleType
            cell.viewDayList.isHidden = true
        }else{
            cell.lblVSheduleText.isHidden = true
            
            let showday = item.MeetingDays
            let dayList = showday!.components(separatedBy: "|")
            print("Show DayList===",dayList)
            
            for val in dayList
            {
                switch(val){
                case "Monday":
                    cell.lblMon.textColor = .blue
                    break;
                case "Tuesday":
                    cell.lblTue.textColor = .blue
                    break;
                case "Wednesday":
                    cell.lblWed.textColor = .blue
                    break;
                case "Thursday":
                    cell.lblThus.textColor = .blue
                    break;
                case "Friday":
                    cell.lblFri.textColor = .blue
                    break;
                case "Saturday":
                    cell.lblSatu.textColor = .blue
                    break;
                default:
                    break;
                    
                }
            }
        }
        
        
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
        //ClassOverviewNav
        let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ClassOverviewNav")
        self.present(controller, animated: true, completion: nil)
    }
   
}


extension ClassesController{
    
    
    // ====== All Class Lists
    
    
    func callAPIGetLassesList(){
        SVProgressHUD.show()
        let parameters = [
            "allCourse":true,
            "markingPeriodStartDate": strorePeriodStartDate,
            "markingPeriodEndDate": strorePeriodEndDate,
            "membershipId":"4",
            "schoolId": storeSchoolID,
            "_academicYear": storeAcademicYears,
            "staffId":storeUserID,
            "tenantId":storeTenantID,
            "_tenantName":storeTenantName,
            "_token":storeToken,
            "_userName":storeName,
            ] as [String : Any];
        print("Param ViewCourseList==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "Common/getDashboardViewForStaff"
        print("URL ViewCourseList==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        print("request ViewCourseList===",request)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("ViewCourseList===",response)
                let json = JSON(data)
                print("json ViewCourseList==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                if status == "false"{
                    let allCourseList = json["courseSectionViewList"].arrayValue
                    self.arrViewCourseList = allCourseList
                    print("arrViewCourseList==",self.arrViewCourseList)
                    
                    let NoticeList = json["noticeList"].arrayValue
                    print("Arr noticeList ==",NoticeList)
                    
                    
                    
                    for val in allCourseList {
                        
                        let showMDay = val["meetingDays"].stringValue
                        let dayList = showMDay.components(separatedBy: "|")
                        print("dayList====",dayList)
                        print("showMDay====",showMDay)
                        // self.currentDay
                       //if dayList.contains("Tuesday"){
                            
                            let courseSectionName = val["courseSectionName"].stringValue
                           let courseSectionId = val["courseSectionId"].stringValue
                           let courseId = val["courseId"].stringValue
                        let qtrMarkingPeriodId = val["qtrMarkingPeriodId"].stringValue
                        let attcatId = val["attendanceCategoryId"].stringValue
                            let courseTitle = val["courseTitle"].stringValue
                            let meetingDays = val["meetingDays"].stringValue
                            let courseGradeLevel = val["courseGradeLevel"].stringValue
                            
                            let courseFSchedule = val["courseFixedSchedule"].dictionaryValue
                        
                        let scheduleType = val["scheduleType"].stringValue
                           
                           if courseFSchedule.isEmpty{
                               print("courseFixedSchedule is Empty====")
                               let courseVSchedule = val["courseVariableSchedule"].arrayValue
                               let courseFSchedule = courseVSchedule[0]
                               
                               let blockPeriod = courseFSchedule["blockPeriod"].dictionaryValue
                               let periodTitle = blockPeriod["periodTitle"]?.stringValue
                               let periodStartTime = blockPeriod["periodStartTime"]?.stringValue
                               
                               let rooms = courseFSchedule["rooms"].dictionaryValue
                               let titleroom = rooms["title"]?.stringValue
                               
                               self.selectedCourseList.append(SelectedCourseList(CourseSectionName: String() + courseSectionName, CourseTitle: String() + courseTitle, MeetingDays: String() + meetingDays, CourseGradeLevel: String() + courseGradeLevel, PeriodTitle: String() + (periodTitle ?? " "), PeriodStartTime: String() + (periodStartTime ?? " "), RoomTitle: String() + (titleroom ?? " "), CourseSectionID: String() + courseSectionId, CourseID: String() + courseId,ScheduleType: String() + scheduleType,attendanceTaken: String() + "",attCatID: String() + "",markingPeriod: qtrMarkingPeriodId))
                               
                           }else{
                               
                               
                               let blockPeriod = courseFSchedule["blockPeriod"]?.dictionaryValue
                               let periodTitle = blockPeriod?["periodTitle"]?.stringValue
                               let periodStartTime = blockPeriod?["periodStartTime"]?.stringValue
                               
                               let rooms = courseFSchedule["rooms"]?.dictionaryValue
                               let titleroom = rooms?["title"]?.stringValue
                               
                               self.selectedCourseList.append(SelectedCourseList(CourseSectionName: String() + courseSectionName, CourseTitle: String() + courseTitle, MeetingDays: String() + meetingDays, CourseGradeLevel: String() + courseGradeLevel, PeriodTitle: String() + (periodTitle ?? " "), PeriodStartTime: String() + (periodStartTime ?? " "), RoomTitle: String() + (titleroom ?? " "), CourseSectionID: String() + courseSectionId, CourseID: String() + courseId,ScheduleType: String() + scheduleType,attendanceTaken: String() + "",attCatID: String() + "",markingPeriod: qtrMarkingPeriodId))
                               
                           }
                        //}
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
    
    
    func callAPIGetLassesList1(){
        
        SVProgressHUD.show()
        
        let parameters = [
            "markingPeriodStartDate": strorePeriodStartDate,
            "markingPeriodEndDate": strorePeriodEndDate,
            "membershipId": stroreMembershipID,
            "allCourse":true,
            "schoolId": storeSchoolID,
            "staffId" : storeUserID,//storeUserID,
            "tenantId":storeTenantID,
            "_tenantName":storeTenantName,
            "_token":storeToken,
            "_userName":storeName
            ] as [String : Any];
        print("Param AllClasses==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "Common/getDashboardViewForStaff"
        print("URL AllClasses==",urlString)
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
                print("json AllClasses==",json)
                let getArrJson = json.arrayValue
                print("getArrJson AllClasses==",getArrJson)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let allSchool = json["courseSectionViewList"].arrayValue
                     self.arrMyClassesList = allSchool
                     print("arr AllClasses List==",self.arrMyClassesList)
                     
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
