//
//  ScheduleController.swift
//  OpenSIS
//
//  Created by Rejaul on 1/11/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ScheduleController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var lblWarningMsg: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblDay: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    
    var  getStartDate = UserDefaults.standard.string(forKey: "Key_PeriodStartDate") ?? ""
    var getEndDate = UserDefaults.standard.string(forKey: "Key_PeriodEndDate") ?? ""
    
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    var arrViewCourseList = [JSON]()
    var selectedSchedule = [SelectedSchedule]()
    
    var currentDay = ""
    
    var count = 0
    var Strcount = ""
    var getClickDate = ""
    var somedateString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //lblWarningMsg.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
        self.tableView.tableFooterView = UIView()
        
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        //show date in label fields
        let date = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MMM dd, yyyy"
        let result = formatter1.string(from: date)
        //currentDate = result
        lblDate.text = result
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        currentDay = dayInWeek
        print("currentDay===",currentDay)
        lblDay.text = currentDay
        callAPIViewCourseList()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btntappedHome(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardNav")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func btnTappedClasses(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ClassesController")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func btnTappedPrevious(_ sender: Any) {
        
        count -= 1
        Strcount = "\(count)"
        print("count+=",count)
        
        
        let date = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MMM dd, yyyy"
        let result = formatter1.string(from: date)
        
        let getDatea = Date()
        let getFormatter = DateFormatter()
        getFormatter.dateFormat = "EEEE"
        let getResult = getFormatter.string(from: getDatea)
        
        
        convertNextDate(dateString: result)
        
        getNextDate(dateString: getResult)
        
        //reportCollectionView.reloadData()
        
    }
    
    @IBAction func btnTappedNext(_ sender: Any) {
        
        count += 1
        Strcount = "\(count)"
        
        print("count-===",count)
        
        
        let date = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MMM dd, yyyy"
        let result = formatter1.string(from: date)
        
        convertNextDate(dateString: result)
        
        let getDatea = Date()
        let getFormatter = DateFormatter()
        getFormatter.dateFormat = "EEEE"
        let getResult = getFormatter.string(from: getDatea)
        
        getNextDate(dateString: getResult)

    }
    
    func convertNextDate(dateString : String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let myDate = dateFormatter.date(from: dateString)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: count, to: myDate)
        somedateString = dateFormatter.string(from: tomorrow!)
        print("Your Next Month is \(somedateString)")
        lblDate.text = somedateString
        
     }
    
    
    
    func getNextDate(dateString : String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let myDate = dateFormatter.date(from: dateString)!
        let tomorrow = Calendar.current.date(byAdding: .weekday, value: count, to: myDate)
        
        getClickDate = dateFormatter.string(from: tomorrow!)
        print("Get your next Date is=== \(getClickDate)")
        
        lblDay.text = "\(getClickDate)"
        currentDay = "\(getClickDate)"
        
        callAPIViewCourseList()
        //reportCollectionView.reloadData()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ScheduleCell
        
        let item = selectedSchedule[indexPath.row]
        cell.lblSubject.text = item.CourseSectionName
        cell.lblPeriod.text = item.PeriodTitle
        cell.lblGrade.text = item.CourseGradeLevel
        cell.lblTime.text = item.PeriodStartTime
        
        //transparents table view cell
            cell.selectionStyle = .none
        return cell
    }
    
    
}


extension ScheduleController{
    
    func callAPIViewCourseList(){
        
        let date = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        let currentdate = formatter1.string(from: date)
        
        
        
        SVProgressHUD.show()
        let parameters = [
            "academicYear":storeAcademicYears,
            "schoolId": storeSchoolID,
            "staffId":storeUserID,
            "tenantId":storeTenantID,
            "_tenantName":storeTenantName,
            "_academicYear": storeAcademicYears,
            "_token":storeToken,
            "_userName":storeName,
            ] as [String : Any];
        print("Parameter Schedule==",parameters)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "Staff/getScheduledCourseSectionsForStaff"
        print("URL Schedule==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("Schedule===",response)
                let json = JSON(data)
                print("json Schedule==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                self.selectedSchedule.removeAll()
                
                if status == "false"{
                    let allCourseList = json["courseSectionViewList"].arrayValue
                    self.arrViewCourseList = allCourseList
                    print("arr Schedule==",self.arrViewCourseList)
                    
                    let fmt = DateFormatter()
                    fmt.dateFormat = "yyyy-MM-dd"
                    
                    for val in allCourseList {
                        
                        let showMDay = val["meetingDays"].stringValue
                        let dayList = showMDay.components(separatedBy: "|")
                        print("dayList====",dayList)
                        //print("showMDay====",showMDay)
                        print("self.currentDay====",self.currentDay)
                        
                        let durationSDate = val["durationStartDate"].stringValue
                        let durationEDate = val["durationEndDate"].stringValue
                        
                        let start = durationSDate.components(separatedBy: "T")
                        let getStart : String = start[0]
                        let end = durationEDate.components(separatedBy: "T")
                        let getEnd : String = end[0]
                      
                      let dateFrom = fmt.date(from: getStart)! // "2018-03-01"
                      let dateTo = fmt.date(from: getEnd)! // "2018-03-05"
                        
                        let CurrentDate = fmt.date(from: currentdate)! // "2018-03-05"
                        
                        //  durationStartDate between   durationEndDate
                          
                          //if meetingDays == currentdays{
                              
                          //}
                        
                        
                        
                        if CurrentDate <= dateTo && CurrentDate >= dateFrom {
                        
                            if dayList.contains(self.currentDay){
                                let courseSectionName = val["courseSectionName"].stringValue
                                let courseTitle = val["courseTitle"].stringValue
                                let meetingDays = val["meetingDays"].stringValue
                                let courseGradeLevel = val["courseGradeLevel"].stringValue
                                
                                let courseFSchedule = val["courseFixedSchedule"].dictionaryValue
                                
                                let courseVariableSchedule = val["courseVariableSchedule"].arrayValue
                                
                                let blockPeriod = courseFSchedule["blockPeriod"]?.dictionaryValue
                                let periodTitle = blockPeriod?["periodTitle"]?.stringValue
                                let periodStartTime = blockPeriod?["periodStartTime"]?.stringValue
                                
                                let rooms = courseFSchedule["rooms"]?.dictionaryValue
                                let titleroom = rooms?["title"]?.stringValue
                                
                                self.selectedSchedule.append(SelectedSchedule(CourseSectionName: String() + courseSectionName, CourseTitle: String() + courseTitle, MeetingDays: String() + meetingDays, CourseGradeLevel: String() + courseGradeLevel, PeriodTitle: String() + (periodTitle ?? " "), PeriodStartTime: String() + (periodStartTime ?? " "), RoomTitle: String() + (titleroom ?? " ")))
                                  
                            }
                           
                           
                       }
                    }
                    
                    if self.selectedSchedule.count == 0{
                        self.lblWarningMsg.text = "No Data Found!"
                    }else{
                        self.lblWarningMsg.text = " "
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



class SelectedSchedule {
    
    var CourseSectionName:String?
    var CourseTitle:String?
    var MeetingDays:String?
    var CourseGradeLevel:String?
    var PeriodTitle:String?
    var PeriodStartTime:String?
    var RoomTitle:String?
    
    init(CourseSectionName: String?, CourseTitle: String?, MeetingDays: String?, CourseGradeLevel:String?, PeriodTitle: String?, PeriodStartTime:String?, RoomTitle:String?) {
        self.CourseSectionName = CourseSectionName
        self.CourseTitle = CourseTitle
        self.MeetingDays = MeetingDays
        self.CourseGradeLevel = CourseGradeLevel
        self.PeriodTitle = PeriodTitle
        self.PeriodStartTime = PeriodStartTime
        self.RoomTitle = RoomTitle
    }
}


extension String {
    var attributedHtmlString: NSAttributedString? {
        try? NSAttributedString(
            data: Data(utf8),
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
}
