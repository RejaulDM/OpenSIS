//
//  CalendarController.swift
//  OpenSIS
//
//  Created by Rejaul on 1/31/23.
//

import UIKit
import FSCalendar
import SwiftyJSON
import SVProgressHUD
import Alamofire


class CalendarController: UIViewController,FSCalendarDataSource,FSCalendarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    fileprivate lazy var dateFormatterGet: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SelectSchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    var stroreMembershipID = UserDefaults.standard.string(forKey: "Key_MembershipID") ?? ""
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    var dataModelEventList = [DataModelEventList]()
    var dataModelTaskList = [DataModelTaskList]()
    
    var arrMonthlyEventList = [JSON]()
    var arrMonthlyTasksList = [JSON]()
    

    var fromDateM = ""
    var toDateM = ""
    
    var mydates : [String] = []
    var dateFrom =  Date() // First date
    var dateTo = Date()   // Last date
    
    var mydatesTask : [String] = []
    var dateFromTask =  Date() // First date
    var dateToTask = Date()   // Last date
    
    var datesWithEvent = [""]
    var datesWithTask = [""]
    
    var allEventDate  = [""]
    var allTaskDate  = [""]
    
    var getClickDate = ""
    
    let option =  Options()
    
    var getUserID = ""
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var lblEventDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
       
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.layer.borderWidth = 1
        //tableView.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        //tableView.layer.cornerRadius = 8
        
        //tableView.isHidden = true
        
        
        let formatter2 = DateFormatter()
               formatter2.locale = Locale(identifier: "en_US_POSIX")
               formatter2.dateFormat = "yyyy-MM-dd"

               var startDate1 = Date()
               var interval2 = TimeInterval()
               Calendar.current.dateInterval(of: .month, start: &startDate1, interval: &interval2, for: Date())
               let endDate = Calendar.current.date(byAdding: .second, value: Int(interval2) - 1, to: startDate1)!

                fromDateM = formatter2.string(from: startDate1)
                toDateM = formatter2.string(from: endDate)
               print("FROMDATE==========",fromDateM)
               print("TODATE==========",toDateM)
        
        
        
        //calendar = FSCalendar(frame: CGRect(x: 0.0, y: 60.0, width: self.view.frame.size.width, height: 300.0))
        
        calendar.scrollDirection = .horizontal
        
        calendar.scope = .month
        //self.view.addSubview(calendar)
        //self.viewSC.(calendar)
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = false
        
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.eventSelectionColor = UIColor.white
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)

        callApiMonthlyEventList()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModelEventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CalendarEventCell
        
        let item = dataModelEventList[indexPath.row]
        cell.lblEventName.text = item.EventName
        
        
        //transparents table view cell
            cell.selectionStyle = .none
        return cell
    }
    
    

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let dateString = self.dateFormatter2.string(from: date)

        if self.allEventDate.contains(dateString) {
            return 1
        }
        if self.allTaskDate.contains(dateString) {
                return 1
            }

        return 0
    }

//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        return 2
//    }
    
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatterGet.string(from: date))")
        
        getClickDate = (self.dateFormatterGet.string(from: date))
        
        print("getClickDate==== \(getClickDate)")
        
        callApiEventDetails()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        print("did deselect date \(self.formatter.string(from: date))")
        //self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }
    
    
    
    // ===== call Api Monthly Event List
    
    func callApiMonthlyEventList(){
        SVProgressHUD.show()
        let parameters =  [
            "calendarEventList":[],
            "assignmentList":[],
            "calendarId":[1],
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID,
            "membershipId": "4",//stroreMembershipID,
            "academicYear":storeAcademicYears
        ] as [String : Any]
        
       
        
        SVProgressHUD.show()
        
        print("param Calendar Event ==",parameters)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "CalendarEvent/getAllCalendarEvent"
        print("URL Calendar===",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {(response) in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                //print(response,"response Calendar Event==")
                let json = JSON(data)
                print("json Calendar Event===",json)
                self.arrMonthlyEventList = json.arrayValue
                
                let getEvecntList = json["calendarEventList"].arrayValue
            
               /* var dateFormate = ""
                
                let DateFormat = UserDefaults.standard.string(forKey: "DateFormat") ?? ""
                print("DateFormat====",DateFormat)
                
                if DateFormat == "DD-MM-YYYY" {
                    dateFormate = "dd-MM-yyyy"
                }else{
                    dateFormate = "MM-dd-yyyy"
                }*/
                //print("GetDateFormatCurrent====",dateFormate)
                
                let fmt = DateFormatter()
                fmt.dateFormat = "yyyy-MM-dd"
                
                  for item in getEvecntList {
                    
                    let sdate = item["startDate"].stringValue
                    print("EventStartDate====",sdate)
                    let edate = item["endDate"].stringValue
                    print("EventEndDate====",edate)
                      
                      let start = sdate.components(separatedBy: "T")
                      let getStart : String = start[0]
                      let end = edate.components(separatedBy: "T")
                      let getEnd : String = end[0]
                    
                    self.dateFrom = fmt.date(from: getStart)! // "2018-03-01"
                    self.dateTo = fmt.date(from: getEnd)! // "2018-03-05"


                    while self.dateFrom <= self.dateTo {
                        self.mydates.append(self.formatter.string(from: self.dateFrom))
                        self.dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: self.dateFrom)!

                    }
                    
                    print("My Dates===",self.mydates) // Your Result
                    
                    self.datesWithEvent = self.mydates
                    
                    self.allEventDate.append(contentsOf: self.datesWithEvent)
                    
                   /* for i in 0..<1{
                        dataModelGoalCreateAssignToGroup.append(DataModelGoalCreateAssignToGroup(groupName: String() + textname, groupID: String() + groupid))
                        
                        //displaying data in tableview
                        
                        
                    }*/
                    
                        
                }
                
                print("allEventDate====",self.allEventDate) // Your Result
                
                self.calendar.reloadData()
                
                
                
                break
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("Request failed with error: \(error)")
                break
            }
        }
        
        
    }
    
    
    func callApiEventDetails(){
        SVProgressHUD.show()
        let parameters =  [
            "calendarEventList":[],
            "assignmentList":[],
            "calendarId":[1],
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID,
            "membershipId": "4",//stroreMembershipID,
            "academicYear":storeAcademicYears
        ] as [String : Any]
        
       
        
        SVProgressHUD.show()
        
        print("param Event Details==",parameters)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "CalendarEvent/getAllCalendarEvent"
        print("URL Calendar===",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {(response) in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print(response,"response Calendar Event==")
                let json = JSON(data)
                print("json Event Details===",json)
                self.arrMonthlyEventList = json.arrayValue
                
                let getEvecntList = json["calendarEventList"].arrayValue
            
                self.dataModelEventList.removeAll()
                let fmt = DateFormatter()
                fmt.dateFormat = "yyyy-MM-dd"
                
                  for item in getEvecntList {
                    
                    let sdate = item["startDate"].stringValue
                    print("EventStartDate==",sdate)
                    let edate = item["endDate"].stringValue
                    print("EventEndDate==",edate)
                      
                      let start = sdate.components(separatedBy: "T")
                      let getStart : String = start[0]
                      let end = edate.components(separatedBy: "T")
                      let getEnd : String = end[0]
                    
                    self.dateFrom = fmt.date(from: getStart)! // "2018-03-01"
                    self.dateTo = fmt.date(from: getEnd)! // "2018-03-05"

                      print("My Dates===",self.mydates)
                   
                      if self.getClickDate == getStart{
                          let eventname = item["title"].stringValue
                          
                              self.dataModelEventList.append(DataModelEventList(EventName: String() + eventname))
                          
                          self.lblEventDate.text = ""
                          
                      }else{
                          self.lblEventDate.text = "Event & Schedule on" + self.getClickDate
                      }
                      
                    
                      DispatchQueue.main.async {
                          self.tableView.reloadData()
                      }
                        
                }
                
                break
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("Request failed with error: \(error)")
                break
            }
        }
        
        
    }
    
    
    @IBAction func btnTappedHome(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardNav")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func btnTappedClass(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ClassesController")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnTappedSchedule(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Schedule", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ScheduleController")
        self.present(controller, animated: true, completion: nil)
    }
    
}


class DataModelEventList {
    
    var EventName: String?
    
    init(EventName: String?) {
        self.EventName = EventName
    }
    
}

class DataModelTaskList {
    
    var taskName: String?
    var taskSatarDate: String?
    var taskEndDate: String?
    var textType: String?
    
    init(taskName: String?, taskSatarDate: String?, taskEndDate: String?, textType: String?) {
        self.taskName = taskName
        self.taskSatarDate = taskSatarDate
        self.taskEndDate = taskEndDate
        self.textType = textType
        
    }
    
}
