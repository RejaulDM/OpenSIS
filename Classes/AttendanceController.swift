//
//  AttendanceController.swift
//  OpenSIS
//
//  Created by Rejaul on 1/22/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import SDWebImage

class AttendanceController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var lblAttendanceMsg: UILabel!
    
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var viewHeaderCons: NSLayoutConstraint! //103
    
    
    @IBOutlet weak var viewHeader1: UIView!
    
    @IBOutlet weak var viewHeader1Cons: NSLayoutConstraint! //45
    
    
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var storeCourseSectionID = UserDefaults.standard.string(forKey: "Key_CourseSectionID") ?? ""
    var storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    let storeAttTakenk = UserDefaults.standard.string(forKey: "Key_AttTakenk") ?? ""
    
    
    
    let iconEmpt = UIImage(named: "student") as UIImage?
    
    var arrAttendanceList = [JSON]()
    
    var presentStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
        self.tableView.tableFooterView = UIView()
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        if storeAttTakenk == "false"{
            tableView.isHidden = true
            viewHeader.isHidden = true
            viewHeaderCons.constant = 0.0
            viewHeader1Cons.constant = 45
            viewHeader1.isHidden = false
        }else{
            tableView.isHidden = false
            viewHeaderCons.constant = 103
            viewHeader.isHidden = false
            viewHeader1Cons.constant = 0.0
            viewHeader1.isHidden = true
        }
        
        callAPIGetAttendancePresentCode()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
     }
    
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        //let CELL_INDEXID = UserDefaults.standard.string(forKey: "CELL_INDEXID")
        //print("CELL_INDEXID======",CELL_INDEXID!)
        //let getIndexID: Int? = Int(CELL_INDEXID!)
        
        let GetRemar = UserDefaults.standard.string(forKey: "GetRemarks") ?? ""
        
        print("GetRemar======",GetRemar)
        
        
       /* let dict = selectAllLabel[getIndexID!]
        let filedid = dict.FieldID
        let getAllValCount = saveAllLabel.count
        print("getAll Label Val Count +++++++" ,getAllValCount)
        
        let dict1 = self.saveAllLabel[self.tappedIndex]
        
        self.selectAllLabel.remove(at: self.tappedIndex)
        dict.LabelFieldText = GetRemar
        selectAllLabel.insert(dict1, at: self.tappedIndex)*/
        
      /*  let dict = selectAllLabel[getIndexID!]
        let fieldid = dict.FieldID
        let fieldkeyname = dict.FieldKeyName
        let fieldname = dict.LabelFieldName
        let fieldtextval = dict.LabelFieldText
        
        selectAllLabel.remove(at: getIndexID!)
        selectAllLabel.insert(AllLabelDetails(FieldID: fieldid,FieldKeyName: fieldkeyname,LabelFieldName: fieldname,LabelFieldText: GetRemar), at: getIndexID!)*/
        
        
        
        
       /* let folderAppend = SaveLabelDetails()
        folderAppend.FieldId = fieldid
        folderAppend.FieldText = GetRemar
        saveAllLabel.append(folderAppend)*/
        
       /*
        
        let getAllValCount = saveAllLabel.count
        print("saveAllLabel +++++++" ,getAllValCount)
        
        let dict1 = selectAllLabel[self.tappedIndex]
        
        selectAllLabel.remove(at: self.tappedIndex)
        
        dict.LabelFieldText = GetRemar
        selectAllLabel.insert(dict1, at: self.tappedIndex) */
        
        
        tableView.reloadData()
        
        
    }
    
    
    @IBAction func btnTapSub(_ sender: Any) {
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAttendanceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendanceCell
        
        let item = arrAttendanceList[indexPath.row]
        
        cell.lblName.text = item["firstGivenName"].stringValue
        cell.lblID.text = "ID :" + item["studentInternalId"].stringValue
        cell.lblAltID.text = "Alt ID :" +  item["alternateId"].stringValue
        cell.lblGrade.text = item["gradeLevel"].stringValue
        
        
        if self.presentStatus == "P"{
            cell.btnTitlePresentSatus.setTitle(self.presentStatus, for: .normal)
        }
        
        
        cell.ClickCellDelegateAtt = self
        cell.indexIDAtt = indexPath

        
        cell.ClickCellDelegateMSG = self
        cell.indexIDMSG = indexPath
        
        let imgPath = item["studentPhoto"].stringValue
        /*let InImgURL = imgPath
        let urlStringImg = InImgURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProfile.sd_setImage(with: URL(string: urlStringImg), placeholderImage: UIImage(named: "")) */
        
        if imgPath == "" {
            print("error with base64String")
            
            cell.imgProfile.image = iconEmpt
            } else {
                let decodedData = NSData(base64Encoded: imgPath, options: [])
                if let data = decodedData {
                    let decodedimage = UIImage(data: data as Data)
                    
                    cell.imgProfile.image = decodedimage
                    } else {
                        print("error with decodedData")
                    }
                }
        
        
        //transparents table view cell
            cell.selectionStyle = .none
        return cell
    }
    
   
}



extension AttendanceController: BtnAttStatus {
    func ClickCellAtt(index: Int) {
        print("\(index) Tapped Call==")
        
        let dict = arrAttendanceList[index]
        let getNo = dict["phoneNumber"].stringValue
        print("getNo===",getNo)
        
        
        let storyboard = UIStoryboard(name: "Classes", bundle: nil)
         let contollerName = storyboard.instantiateViewController(withIdentifier: "AttendanceMarkPopup")
         self.present(contollerName, animated: true, completion: nil)
        
    }
    
}

extension AttendanceController:BtnMSG {
    func ClickCellMSG(index: Int) {
        print("\(index) Tapped Mail==")
        
        let vc = AttendanceTextRemarks()
         vc.modalTransitionStyle = .crossDissolve
         vc.modalPresentationStyle = .overCurrentContext
         self.present(vc, animated: true, completion: nil)
        
    }
    
}

extension AttendanceController{
    // ====== Attendance Present Default Code
    
    func callAPIGetAttendancePresentCode(){
        SVProgressHUD.show()
        let parameters = [
            "attendanceCodeList": [],
            "attendanceCategoryId":1,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID,
            "academicYear":storeAcademicYears
            
            ] as [String : Any];
        print("Param Attendance Status==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "AttendanceCode/getAllAttendanceCode"
        print("URL Attendance==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                //print("att Status===",response)
                let json = JSON(data)
                print("json Attendance Status==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let allSchool = json["attendanceCodeList"].arrayValue
                     
                     for val in allSchool {
                         let getshortName = val["shortName"].stringValue
                         if getshortName == "P"{
                             self.presentStatus = getshortName
                         }
                         
                     }
                     
                     print("arrAttendanceStatus==",self.presentStatus)
                     self.callAPIGetAttendanceList()
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
    
    
    
    // ====== All Student Att Lists
    
    func callAPIGetAttendanceList(){
        SVProgressHUD.show()
        
        let parameters = [
            "pageNumber":1,
            "_pageSize":10,
            "sortingModel":"",
            "filterParams":[],
            "courseSectionIds":[storeCourseSectionID],
            "includeInactive":false,
            "profilePhoto":true,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID
            
            ] as [String : Any];
        print("Param Attendance==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StudentSchedule/getStudentListByCourseSection"
        print("URL Attendance==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("StudentResponse===",response)
                let json = JSON(data)
                print("json Attendance==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let allSchool = json["scheduleStudentForView"].arrayValue
                     self.arrAttendanceList = allSchool
                     print("arrAttendanceList==",self.arrAttendanceList)
                     
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
    
    
    // ====== All Att Code
    
    func callAPIGetAttendanceCode(){
        SVProgressHUD.show()
        
        let parameters = [
            "pageNumber":1,
            "_pageSize":10,
            "sortingModel":"",
            "filterParams":[],
            "courseSectionIds":[storeCourseSectionID],
            "includeInactive":false,
            "profilePhoto":true,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID
            ] as [String : Any];
        print("Param Attendance Code==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "AttendanceCode/getAllAttendanceCode"
        print("URL Attendance Code==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("StudentResponse Code===",response)
                let json = JSON(data)
                print("json Attendance Code==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let allSchool = json["scheduleStudentForView"].arrayValue
                     
                     print("arrAttendanceList==",self.arrAttendanceList)
                     
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
