//
//  SearchPopupDash.swift
//  OpenSIS
//
//  Created by Rejaul on 2/15/23.
//

import UIKit
import iOSDropDown
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SearchPopupDash: UIViewController {

    @IBOutlet weak var dropdownSchool: DropDown!
    
    @IBOutlet weak var dropdownSchoolYear: DropDown!
    
    @IBOutlet weak var dropdownMarkingPeriod: DropDown!
    
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view3: UIView!
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var  storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    var SelectSchoolID = ""
    
    var currentDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dropdownCompart
        dropdownSchool.inputView = UIView()
        self.dropdownSchool.tintColor = .clear
        dropdownSchool.borderStyle = UITextField.BorderStyle.none
        dropdownSchool.borderStyle = .none
        dropdownSchool.isSearchEnable = false
        
        dropdownSchoolYear.inputView = UIView()
        self.dropdownSchoolYear.tintColor = .clear
        dropdownSchoolYear.borderStyle = UITextField.BorderStyle.none
        dropdownSchoolYear.borderStyle = .none
        dropdownSchoolYear.isSearchEnable = false
        
        dropdownMarkingPeriod.inputView = UIView()
        self.dropdownMarkingPeriod.tintColor = .clear
        dropdownMarkingPeriod.borderStyle = UITextField.BorderStyle.none
        dropdownMarkingPeriod.borderStyle = .none
        dropdownMarkingPeriod.isSearchEnable = false
        
        
        
        
        view1.layer.cornerRadius = 4
        view1.layer.masksToBounds = true
        view1.layer.borderWidth = 1
        view1.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        view2.layer.cornerRadius = 4
        view2.layer.masksToBounds = true
        view2.layer.borderWidth = 1
        view2.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        view3.layer.cornerRadius = 4
        view3.layer.masksToBounds = true
        view3.layer.borderWidth = 1
        view3.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        //show date in label fields
        let date = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        let result = formatter1.string(from: date)
        currentDate = result
        
        
        callAPISchoolDropdownList()
        
        callAPIYearList()
        
        callAPIQuaterList()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnTappedCancel(_ sender: Any) {
        self.dismiss(animated: true){
           
        }
    }
    

    @IBAction func btnTappedSubmite(_ sender: Any) {
        
        self.dismiss(animated: true){
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        }
        
        
    }
    
    
    
    //======= dropdownSchool
    func callAPISchoolDropdownList(){
        
        SVProgressHUD.show()
        let parameters =  [
            "emailAddress":storeEmail,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID
            ] as [String : Any]
        print("parameters SchoolDropdownList=",parameters)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "School/getAllSchools"
        print("URL SchoolDropdownList===",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {(response) in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                let json = JSON(data)
                print(" Json SchoolDropdownList",json)
                
                let getSchoolForView = json["getSchoolForView"].arrayValue
                let option =  Options()
               
                    for item in getSchoolForView {
                        
                        var schoolName = item["schoolName"].stringValue
                        print("schoolName===",schoolName)
                        var schoolId = item["schoolId"].stringValue
                        print("schoolId====",schoolId)
                        
                        if self.storeSchoolID == schoolId{
                            var schoolName = item["schoolName"].stringValue
                            self.dropdownSchool.text = schoolName
                            print("schoolName===",schoolName)
                            var schoolId = item["schoolId"].stringValue
                            print("schoolId====",schoolId)
                            UserDefaults.standard.set(schoolId, forKey: "Key_SchoolID")
                        }
                        
                        option.selectSchoolName.append(schoolName)
                        option.selectSchoolID.append(schoolId)
                        
                        
                        self.dropdownSchool.optionArray = option.selectSchoolName
                        self.dropdownSchool.optionIds = option.ids
                        //var id = option.ids
                        //dropdownMethods.checkMarkEnabled = false
                        self.dropdownSchool.didSelect{(selectedText , index , id) in
                            self.SelectSchoolID = option.selectSchoolID[index]
                            let schoolid = option.selectSchoolID[index]
                        print("SelectSchoolID===",schoolid)
                            UserDefaults.standard.set(schoolid, forKey: "Key_SchoolID")
                             
                        }
                    }
                    
                    SVProgressHUD.dismiss()
                
                
                break
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("Request failed with error: \(error)")
                break
            }
        }
        
    }
    
    
    //======= dropdownSchool
    func callAPIYearList(){
        
        SVProgressHUD.show()
        let parameters =  [
            "schoolId":storeSchoolID,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID
            ] as [String : Any]
        print("parameters YearList=",parameters)
        
        
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "MarkingPeriod/getAcademicYearList"
        print("URL YearList===",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {(response) in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                let json = JSON(data)
                print(" Json YearList",json)
                
                let getSchoolForView = json["academicYears"].arrayValue
                print("getSchoolForView==",getSchoolForView)
                let option =  Options()
               
                    for item in getSchoolForView {
                        
                        var year = item["year"].stringValue
                        print("year===",year)
                        var startDate = item["startDate"].stringValue
                        print("startDate====",startDate)
                        var endDate = item["endDate"].stringValue
                        print("endDate====",endDate)
                        var accayear = item["academyYear"].stringValue
                        print("accayear===",accayear)
                        if self.storeAcademicYears == accayear{
                            
                            self.dropdownSchoolYear.text = year
                            UserDefaults.standard.set(accayear, forKey: "Key_AcademicYears")
                        }
                        
                        
                        option.selectYearName.append(year)
                        option.selectAccaYear.append(accayear)
                        option.selectYearSDate.append(startDate)
                        option.selectYearEDate.append(endDate)
                        
                        
                        self.dropdownSchoolYear.optionArray = option.selectYearName
                        self.dropdownSchoolYear.optionIds = option.ids
                        //var id = option.ids
                        //dropdownMethods.checkMarkEnabled = false
                        self.dropdownSchoolYear.didSelect{(selectedText , index , id) in
                            let accYear = option.selectAccaYear[index]
                            print("accYear===",accYear)
                            UserDefaults.standard.set(accYear, forKey: "Key_AcademicYears")
                            let sdate = option.selectYearSDate[index]
                            let edate = option.selectYearEDate[index]
                        print(sdate,edate,"sdate edate==")
                            
                        }
                    }
                    
                    SVProgressHUD.dismiss()
                
                
                break
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("Request failed with error: \(error)")
                break
            }
        }
        
    }
    
    
    
    //======= dropdownSchool
    func callAPIQuaterList(){
        
        SVProgressHUD.show()
        let parameters =  [
            "schoolId":storeSchoolID,
            "academicYear":storeAcademicYears,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID
            ] as [String : Any]
        print("parameters QuaterList=",parameters)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "MarkingPeriod/getMarkingPeriodTitleList"
        print("URL Quater===",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {(response) in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                let json = JSON(data)
                print(" Json QuaterList",json)
                
                let getSchoolForView = json["period"].arrayValue
                let option =  Options()
               
                    for item in getSchoolForView {
                        
                        let periodTitle = item["periodTitle"].stringValue
                        print("periodTitle===",periodTitle)
                        let markingPeriodId = item["markingPeriodId"].stringValue
                        print("markingPeriodId====",markingPeriodId)
                        
                        
                        let sdate = item["startDate"].stringValue
                        let edate = item["endDate"].stringValue
                        let start = sdate.components(separatedBy: "T")
                        let getStart : String = start[0]
                        let end = edate.components(separatedBy: "T")
                        let getEnd : String = end[0]
                        
                        
                        if self.currentDate >= getStart && self.currentDate <= getEnd{
                            let FSdate = item["startDate"].stringValue
                            let FEdate = item["endDate"].stringValue
                            UserDefaults.standard.set(FSdate, forKey: "Key_PeriodStartDate")
                            UserDefaults.standard.set(FEdate, forKey: "Key_PeriodEndDate")
                            print("FSdate==",FSdate,"FEdate==",FEdate)
                            
                            let periodTitle = item["periodTitle"].stringValue
                            self.dropdownMarkingPeriod.text = periodTitle
                        }
                        
                        
                        
                        option.selectPeriodTitle.append(periodTitle)
                        option.selectMarkingPeriodId.append(markingPeriodId)
                        
                        
                        self.dropdownMarkingPeriod.optionArray = option.selectPeriodTitle
                        self.dropdownMarkingPeriod.optionIds = option.ids
                        //var id = option.ids
                        //dropdownMethods.checkMarkEnabled = false
                        self.dropdownMarkingPeriod.didSelect{(selectedText , index , id) in
                            let mid = option.selectMarkingPeriodId[index]
                       print(mid,"mid==")
                            
                        }
                    }
                    
                    SVProgressHUD.dismiss()
                
                
                break
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("Request failed with error: \(error)")
                break
            }
        }
        
    }
    
}
