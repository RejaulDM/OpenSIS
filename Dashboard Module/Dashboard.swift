//
//  Dashboard.swift
//  OpenSIS
//
//  Created by Rejaul on 11/23/22.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class Dashboard: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var viewAttendanceMiss: UIView!
    
    @IBOutlet weak var viewAttendanceMissCons: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewNotification: UIView!
    
    @IBOutlet weak var viewNotificationCons: NSLayoutConstraint!
    
    @IBOutlet weak var subViewNotification: UIView!
    
    @IBOutlet weak var subViewNotiShowAll: UIView!
    
    @IBOutlet weak var viewNotice: UIView!
    @IBOutlet weak var innerViewNotice: UIView!
    @IBOutlet weak var lblNoticeHeader: UILabel!
    @IBOutlet weak var textNoticeDec: UITextView!
    
    
    
    @IBOutlet weak var viewUpcoming: UIView!
    @IBOutlet weak var innerViewUpcoming: UIView!
    @IBOutlet weak var lblGreenCirclu: UILabel!
    @IBOutlet weak var lblRedCirclu: UILabel!
    @IBOutlet weak var lblBlueCirclu: UILabel!
    
    @IBOutlet weak var viewEvent1: UIView!
    @IBOutlet weak var lblEvent1: UILabel!
    @IBOutlet weak var lblEventDate1: UILabel!
    
    @IBOutlet weak var viewEvent2: UIView!
    @IBOutlet weak var lblEvent2: UILabel!
    @IBOutlet weak var lblEventDate2: UILabel!
    
    @IBOutlet weak var viewEvent3: UIView!
    
    @IBOutlet weak var lblEvent3: UILabel!
    @IBOutlet weak var lblEventDate3: UILabel!
    
    
    @IBOutlet weak var lblNoClassMsg: UILabel!
    
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var stroreMembershipID = UserDefaults.standard.string(forKey: "Key_MembershipID") ?? ""
    var storeLogoData  = UserDefaults.standard.string(forKey: "Key_Base64") ?? ""
    var BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    
    var arrViewCourseList = [JSON]()
    
    var selectedCourseList = [SelectedCourseList]()
    
    var currentDate = ""
    
    var getStartDate = ""
    var getEndDate = ""
    var AcademicYear = ""
    var currentDay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblNoClassMsg.isHidden = true
        viewEvent1.isHidden = true
        viewEvent2.isHidden = true
        viewEvent3.isHidden = true
        
        viewUpcoming.isHidden = true
        
        viewAttendanceMiss.isHidden = true
        viewAttendanceMissCons.constant = 0
        
        viewNotification.isHidden = true
        viewNotificationCons.constant = 0
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        imgLogo.setRounded()
        
        lblGreenCirclu.layer.cornerRadius = lblGreenCirclu.frame.width/2
        lblGreenCirclu.layer.masksToBounds = true
        
        lblRedCirclu.layer.cornerRadius = lblRedCirclu.frame.width/2
        lblRedCirclu.layer.masksToBounds = true
        
        lblBlueCirclu.layer.cornerRadius = lblBlueCirclu.frame.width/2
        lblBlueCirclu.layer.masksToBounds = true
        
        viewAttendanceMiss.layer.borderWidth = 2
        viewAttendanceMiss.layer.cornerRadius = 6
        viewAttendanceMiss.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        

        viewNotification.layer.cornerRadius = 10
        viewNotification.layer.borderWidth = 1
        viewNotification.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        subViewNotification.layer.cornerRadius = 10
        subViewNotification.layer.borderWidth = 1
        subViewNotification.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        viewNotice.layer.cornerRadius = 10
        viewNotice.layer.borderWidth = 1
        viewNotice.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        innerViewNotice.layer.cornerRadius = 10
        innerViewNotice.layer.borderWidth = 1
        innerViewNotice.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        viewUpcoming.layer.cornerRadius = 10
        viewUpcoming.layer.borderWidth = 1
        viewUpcoming.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        innerViewUpcoming.layer.cornerRadius = 10
        innerViewUpcoming.layer.borderWidth = 1
        innerViewUpcoming.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //show date in label fields
        let date = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        let result = formatter1.string(from: date)
        currentDate = result
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        currentDay = dayInWeek
        print("currentDay===",currentDay)
       /* let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)*/
        
        callAPIAcademicYear()
        CallApiGetLogo()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        
        //let GetRemar = UserDefaults.standard.string(forKey: "GetRemarks") ?? ""
        //print("GetRemar======",GetRemar)
        
        callAPIViewCourseList()
    
    }
    

    @IBAction func btnTappedSearchDetails(_ sender: Any) {
        
        let vc = SearchPopupDash()
         vc.modalTransitionStyle = .crossDissolve
         vc.modalPresentationStyle = .overCurrentContext
         self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnTappedSideMenu(_ sender: UIButton) {
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
            }, completion:nil)
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
    
    
    // Wie viele Objekete soll es geben?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCourseList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardTodayClassCell", for: indexPath) as! DashboardTodayClassCell
            
        let item = selectedCourseList[indexPath.row]
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
                cell.lblSat.textColor = .blue
                break;
            default:
                break;
                
            }
        }
        
            cell.lblSubjectCode.text = item.CourseSectionName
            cell.lblCourseSection.text = item.CourseTitle
            cell.lblGrade.text = item.CourseGradeLevel
            cell.lblTime.text = item.PeriodStartTime
            cell.lblRoomCode.text = item.RoomTitle
            cell.lblPeriod.text = item.PeriodTitle
        

            
        cell.lblDot.layer.cornerRadius = cell.lblDot.frame.width/2
        cell.lblDot.layer.masksToBounds = true
            
        cell.viewBack.layer.cornerRadius = 8
        cell.viewBack.layer.borderWidth = 1
        cell.viewBack.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
            
        cell.lblRoomCode.layer.cornerRadius = 8
        cell.lblRoomCode.layer.borderWidth = 1
        cell.lblRoomCode.layer.borderColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        cell.lblRoomCode.layer.masksToBounds = true
        
            //cell.viewBack.addShadowView()
            
            return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = selectedCourseList[indexPath.row]
        let sectionID = item.CourseSectionID
        let courseID = item.CourseID
        let sectionname = item.CourseSectionName
        let attTakenk = item.attendanceTaken
        
        
        print("sectionID====",sectionID, "courseID===",courseID, "attTakenk==",attTakenk)
        UserDefaults.standard.set(sectionID, forKey: "Key_CourseSectionID")
        
        UserDefaults.standard.set(courseID, forKey: "Key_CourseID")
        
        UserDefaults.standard.set(sectionname, forKey: "Key_CourseName")
        UserDefaults.standard.set("0", forKey: "Key_IndexId")
        
        UserDefaults.standard.set(attTakenk, forKey: "Key_AttTakenk")
        
        let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ClassOverviewNav")
        self.present(controller, animated: true, completion: nil)
    }
    
}

extension UIImageView {

   func setRounded() {
      let radius = CGRectGetWidth(self.frame) / 2
      self.layer.cornerRadius = radius
      self.layer.masksToBounds = true
   }
}


extension Dashboard{
    
    
    func CallApiGetLogo(){
        let GetSubURL = UserDefaults.standard.string(forKey: "Key_SubURL")
        let baseUrl = GetSubURL! + ":8088/"
        
        let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
        let TentName = UserDefaults.standard.string(forKey: "Key_TentName") ?? ""
      
        SVProgressHUD.show()
        
        let parameters = [
            "tenant":[
            "id":0,
            "tenantName":TentName,
            "tenantId":"",
            "isActive":false,
            "tenantFooter":"",
            "tenantLogo":"",
            "tenantLogoIcon":"",
            "tenantFavIcon":"",
            "tenantSidenavLogo":""
            
        ]
            ] as [String : Any];
        
       print("param GetLogo==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
       let jsonString1 = String(data: jsonData, encoding: String.Encoding.ascii)!
       
        let urlString = baseUrl + "api/CatalogDB/CheckIfTenantIsAvailable"
        print("URL GetLogo=====",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        print("request ValidateLogin===",request)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                
                //print("Login Response====",response)
                let json = JSON(data)
                print("json GetLogo====",json)
                
                let LoginStatus = json["failure"].stringValue
                print("LoginStatus==",LoginStatus)
                
                let userId = json["userId"].stringValue
                let email = json["email"].stringValue
                let message = json["_message"].stringValue
                
                if LoginStatus == "false"{
                    
                    let jsontenant = json["tenant"].dictionaryValue
                    
                    let getBase64Str = jsontenant["tenantLogo"]?.stringValue
                    
                    UserDefaults.standard.set(getBase64Str, forKey: "Key_Base64")
                    print("getBase64Str===",getBase64Str)
                    if getBase64Str == "" {
                        print("error with base64String")
                        } else {
                            let decodedData = NSData(base64Encoded: getBase64Str!, options: [])
                            if let data = decodedData {
                                let decodedimage = UIImage(data: data as Data)
                                
                                self.imgLogo.image = decodedimage
                                } else {
                                    print("error with decodedData")
                                }
                            }

                }else{
                    //self.displayAlertMessage(messageToDisplay: message)
                }
                
                break
            case .failure(let error):
                
                SVProgressHUD.dismiss()
                print("Request failed with error: \(error)")
                break
            }
            
            
        }
    }
    
    
    func callAPIAcademicYear(){
        SVProgressHUD.show()
        let parameters = [
            "schoolId": storeSchoolID,
            "tenantId":storeTenantID,
            "_tenantName":storeTenantName,
            "_token":storeToken,
            "_userName":storeName,
            ] as [String : Any];
        print("Param AcademicYear==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "MarkingPeriod/getAcademicYearList"
        print("URL AcademicYear==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("AcademicYear===",response)
                let json = JSON(data)
                print("json AcademicYear==",json)
                let getArrJson = json.arrayValue
                print("AcademicYear==",getArrJson)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let acayear = json["academicYears"].arrayValue
                     
                     print("acayear==",acayear)
                     let getDictYaer = acayear[0]
                     UserDefaults.standard.set(getDictYaer["academyYear"].stringValue, forKey: "Key_AcademicYears")
                     let getYear = getDictYaer["academyYear"].stringValue
                     let year = getYear.components(separatedBy: ".")
                     let getStart : String = year[0]
                     self.AcademicYear = getStart
                     
                     self.callAPIAcademicPeriodList()
                     self.callAPIUpcommingEvent()
                     
                 }else{
                    //self.displayAlertMessage(messageToDisplay: message)
                 }
                DispatchQueue.main.async {
                    //self.collectionView.reloadData()
                }
                
                break
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("Request failed with error: \(error)")
                break
            }
            
            
        }
    }
    
    func callAPIAcademicPeriodList(){
        SVProgressHUD.show()
        let parameters = [
            "academicYear":AcademicYear,
            "schoolId": storeSchoolID,
            "tenantId":storeTenantID,
            "_tenantName":storeTenantName,
            "_token":storeToken,
            "_userName":storeName,
            ] as [String : Any];
        print("Param PeriodList==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "MarkingPeriod/getMarkingPeriodTitleList"
        print("URL PeriodList==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("PeriodList===",response)
                let json = JSON(data)
                print("json PeriodList==",json)
                let getArrJson = json.arrayValue
                print("PeriodList==",getArrJson)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let allperiodList = json["period"].arrayValue
                     print("allperiodList==",allperiodList)
                     
                     for val in allperiodList {
                         
                         let sdate = val["startDate"].stringValue
                         let edate = val["endDate"].stringValue
                         let start = sdate.components(separatedBy: "T")
                         let getStart : String = start[0]
                         let end = edate.components(separatedBy: "T")
                         let getEnd : String = end[0]
                         
                         
                         if self.currentDate >= getStart && self.currentDate <= getEnd{
                             let FSdate = val["startDate"].stringValue
                             let FEdate = val["endDate"].stringValue
                             
                             self.getStartDate = FSdate
                             self.getEndDate = FEdate
                             UserDefaults.standard.set(FSdate, forKey: "Key_PeriodStartDate")
                             UserDefaults.standard.set(FEdate, forKey: "Key_PeriodEndDate")
                             print("FSdate==",FSdate,"FEdate==",FEdate)
                             
                         }
                         
                     }
                     print("current date==",self.currentDate)
                     self.callAPIViewCourseList()
                 }else{
                    //self.displayAlertMessage(messageToDisplay: message)
                 }
                DispatchQueue.main.async {
                    //self.collectionView.reloadData()
                }
                
                break
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("Request failed with error: \(error)")
                break
            }
            
            
        }
    }
    
    // ======
    
    func callAPIViewCourseList(){
        SVProgressHUD.show()
        let parameters = [
            "allCourse":true,
            "markingPeriodStartDate":getStartDate,
            "markingPeriodEndDate":getEndDate,
            "membershipId":"4",
            "schoolId": storeSchoolID,
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
                    
                    self.selectedCourseList.removeAll()
                    
                    let NoticeList = json["noticeList"].arrayValue
                    print("Arr noticeList ==",NoticeList)
                    
                    if NoticeList.count == 0{
                        self.viewNotice.isHidden = true
                    }else{
                      let getnotice = NoticeList[0]
                        let getNoticeHeadr = getnotice["title"].stringValue
                        let getNoticeDec = getnotice["body"].stringValue
                        self.lblNoticeHeader.text = getNoticeHeadr
                        self.textNoticeDec.text = getNoticeHeadr
                        
                    }
                    
                    
                    for val in allCourseList {
                        
                        let showMDay = val["meetingDays"].stringValue
                        let dayList = showMDay.components(separatedBy: "|")
                        print("dayList====",dayList)
                        print("showMDay====",showMDay)
                        //
                       if dayList.contains(self.currentDay){
                            
                            let courseSectionName = val["courseSectionName"].stringValue
                           let courseSectionId = val["courseSectionId"].stringValue
                           let courseId = val["courseId"].stringValue
                            let courseTitle = val["courseTitle"].stringValue
                            let meetingDays = val["meetingDays"].stringValue
                            let courseGradeLevel = val["courseGradeLevel"].stringValue
                           let attendanceTaken = val["attendanceTaken"].stringValue
                            
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
                               
                               self.selectedCourseList.append(SelectedCourseList(CourseSectionName: String() + courseSectionName, CourseTitle: String() + courseTitle, MeetingDays: String() + meetingDays, CourseGradeLevel: String() + courseGradeLevel, PeriodTitle: String() + (periodTitle ?? " "), PeriodStartTime: String() + (periodStartTime ?? " "), RoomTitle: String() + (titleroom ?? " "), CourseSectionID: String() + courseSectionId, CourseID: String() + courseId,ScheduleType: String() + scheduleType,attendanceTaken: String() + attendanceTaken))
                               
                           }else{
                               
                               
                               let blockPeriod = courseFSchedule["blockPeriod"]?.dictionaryValue
                               let periodTitle = blockPeriod?["periodTitle"]?.stringValue
                               let periodStartTime = blockPeriod?["periodStartTime"]?.stringValue
                               
                               let rooms = courseFSchedule["rooms"]?.dictionaryValue
                               let titleroom = rooms?["title"]?.stringValue
                               
                               self.selectedCourseList.append(SelectedCourseList(CourseSectionName: String() + courseSectionName, CourseTitle: String() + courseTitle, MeetingDays: String() + meetingDays, CourseGradeLevel: String() + courseGradeLevel, PeriodTitle: String() + (periodTitle ?? " "), PeriodStartTime: String() + (periodStartTime ?? " "), RoomTitle: String() + (titleroom ?? " "), CourseSectionID: String() + courseSectionId, CourseID: String() + courseId,ScheduleType: String() + scheduleType,attendanceTaken: String() + attendanceTaken))
                               
                           }
                        }else{
                            //self.lblNoClassMsg.isHidden = false
                        }
                    }
                    
                    if self.selectedCourseList.count == 0{
                        self.lblNoClassMsg.isHidden = false
                    }
                    
                }else{
                    //self.displayAlertMessage(messageToDisplay: message)
                 }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
                break
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("Request failed with error: \(error)")
                break
            }
            
            
        }
    }
    
    
    // ====== Notification
    
    func callAPIViewNotification(){
        SVProgressHUD.show()
        let parameters = [
            "allCourse":true,
            "markingPeriodStartDate":getStartDate,
            "markingPeriodEndDate":getEndDate,
            "membershipId":"4",
            "schoolId": storeSchoolID,
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
                    
                    
                    for val in allCourseList {
                        
                        let showMDay = val["meetingDays"].stringValue
                        let dayList = showMDay.components(separatedBy: "|")
                        print("dayList====",dayList)
                        print("showMDay====",showMDay)
                        // "Friday"
                       if dayList.contains(self.currentDay){
                            
                            let courseSectionName = val["courseSectionName"].stringValue
                           let courseSectionId = val["courseSectionId"].stringValue
                           let courseId = val["courseId"].stringValue
                            let courseTitle = val["courseTitle"].stringValue
                            let meetingDays = val["meetingDays"].stringValue
                            let courseGradeLevel = val["courseGradeLevel"].stringValue
                           let attendanceTaken = val["attendanceTaken"].stringValue
                            
                            let courseFSchedule = val["courseFixedSchedule"].dictionaryValue
                           
                               let blockPeriod = courseFSchedule["blockPeriod"]?.dictionaryValue
                               let periodTitle = blockPeriod?["periodTitle"]?.stringValue
                               let periodStartTime = blockPeriod?["periodStartTime"]?.stringValue
                               
                               let rooms = courseFSchedule["rooms"]?.dictionaryValue
                               let titleroom = rooms?["title"]?.stringValue
                           let scheduleType = val["scheduleType"].stringValue
                               
                           self.selectedCourseList.append(SelectedCourseList(CourseSectionName: String() + courseSectionName, CourseTitle: String() + courseTitle, MeetingDays: String() + meetingDays, CourseGradeLevel: String() + courseGradeLevel, PeriodTitle: String() + (periodTitle ?? " "), PeriodStartTime: String() + (periodStartTime ?? " "), RoomTitle: String() + (titleroom ?? " "), CourseSectionID: String() + courseSectionId, CourseID: String() + courseId,ScheduleType: String() + (scheduleType),attendanceTaken: String() + attendanceTaken))
                               
                           
                       }else{
                           self.lblNoClassMsg.isHidden = false
                       }
                    }
                    
                    
                }else{
                    //self.displayAlertMessage(messageToDisplay: message)
                 }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
                break
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("Request failed with error: \(error)")
                break
            }
            
            
        }
    }
    
    
    // Upcomming Calendar Event
    
    func callAPIUpcommingEvent(){
        SVProgressHUD.show()
        let parameters = [
            "noticeList":[],
            "membershipId": "4",//stroreMembershipID,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID,
            "academicYear": AcademicYear
            ] as [String : Any];
        print("Param Event==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "Common/getDashboardViewForCalendarView"
        
        print("URL Event==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("View Event===",response)
                let json = JSON(data)
                print("json View Event==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                if status == "false"{
                    let allEventList = json["calendarEventList"].arrayValue
                   print("arr Event List==",allEventList)
                    
                    if allEventList.count == 0{
                        
                    }else{
                        if  allEventList.count == 1{
                            
                            let getEvent1 = allEventList[0]
                            let event1 = getEvent1["title"].stringValue
                            self.lblEvent1.text = event1
                            let eventSDate1 = getEvent1["startDate"].stringValue
                            let eventEDate1 = getEvent1["endDate"].stringValue
                            
                            let start = eventSDate1.components(separatedBy: "T")
                            let getStart : String = start[0]
                            let end = eventEDate1.components(separatedBy: "T")
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
                            self.lblEventDate1.text = resultString
                            self.viewEvent1.isHidden = false
                            self.viewUpcoming.isHidden = false
                        } else if allEventList.count == 2{
                            
                            let getEvent1 = allEventList[1]
                            let event1 = getEvent1["title"].stringValue
                            self.lblEvent2.text = event1
                            let eventSDate1 = getEvent1["startDate"].stringValue
                            let eventEDate1 = getEvent1["endDate"].stringValue
                            
                            let start = eventSDate1.components(separatedBy: "T")
                            let getStart : String = start[0]
                            let end = eventEDate1.components(separatedBy: "T")
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
                            self.lblEventDate2.text = resultString
                            
                            self.viewEvent2.isHidden = false
                            self.viewUpcoming.isHidden = false
                        }
                        
                    }
                    
                    
                    
                }else{
                    //self.displayAlertMessage(messageToDisplay: message)
                 }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
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


class SelectedCourseList {
    
    var CourseSectionName:String?
    var CourseTitle:String?
    var MeetingDays:String?
    var CourseGradeLevel:String?
    var PeriodTitle:String?
    var PeriodStartTime:String?
    var RoomTitle:String?
    var CourseSectionID:String?
    var CourseID:String?
    var ScheduleType:String?
    var attendanceTaken:String?
    
    init(CourseSectionName: String?, CourseTitle: String?, MeetingDays: String?, CourseGradeLevel:String?, PeriodTitle: String?, PeriodStartTime:String?, RoomTitle:String?,CourseSectionID:String?,CourseID:String?,ScheduleType:String?,attendanceTaken:String?) {
        self.CourseSectionName = CourseSectionName
        self.CourseTitle = CourseTitle
        self.MeetingDays = MeetingDays
        self.CourseGradeLevel = CourseGradeLevel
        self.PeriodTitle = PeriodTitle
        self.PeriodStartTime = PeriodStartTime
        self.RoomTitle = RoomTitle
        self.CourseSectionID = CourseSectionID
        self.CourseID = CourseID
        self.CourseID = CourseID
        self.ScheduleType = ScheduleType
        self.attendanceTaken = attendanceTaken
    }
}



