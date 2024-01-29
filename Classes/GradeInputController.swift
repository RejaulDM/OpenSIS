//
//  GradeInputController.swift
//  OpenSIS
//
//  Created by Rejaul on 5/16/23.
//

import UIKit
import iOSDropDown
import SVProgressHUD
import Alamofire
import SwiftyJSON

class GradeInputController: UIViewController {
    
    
    @IBOutlet weak var dropdownMarkeingPeriod: DropDown!
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnActionSwitch: UISwitch!
    
    
    var container: GradeInputContainer!
    
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
    var storeCourseSectionID = UserDefaults.standard.string(forKey: "Key_CourseSectionID") ?? ""
    var storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHeader.isHidden = true
        
        dropdownMarkeingPeriod.attributedPlaceholder = NSAttributedString(string: "Marking Period", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        self.dropdownMarkeingPeriod.layer.borderWidth = 1
        self.dropdownMarkeingPeriod.layer.cornerRadius = 5
        self.dropdownMarkeingPeriod.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        //container!.segueIdentifierReceivedFromParent("SegueLatterGrade")
        //SegueLatterPercent
        
        callAPIMarkingPeriod()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnSwitch(_ sender: Bool) {
        if btnActionSwitch.isOn {
            print("switchIsOn===")
            container!.segueIdentifierReceivedFromParent("SegueLatterGrade")
        } else {
            print("switchIsOff===")
            container!.segueIdentifierReceivedFromParent("SegueLatterPercent")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueGradeInput"{
            container = segue.destination as? GradeInputContainer
            
            container.animationDurationWithOptions = (0.5, .transitionCrossDissolve)
        }
    }

}
extension GradeInputController{
    
    func callAPIMarkingPeriod(){
        
        SVProgressHUD.show()
        let parameters = [
            "courseSectionId":storeCourseSectionID,
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID,
            "academicYear":storeAcademicYears,
            "markingPeriodStartDate":strorePeriodStartDate,
            "markingPeriodEndDate":strorePeriodEndDate
            ] as [String : Any]
        
        print("paras marking period list=",parameters)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        print("JSON==",jsonData)
        let urlString = BaseURL + "MarkingPeriod/getMarkingPeriodsByCourseSection"
        print("URL marking period list===",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {(response) in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("marking period list====",response)
                let json = JSON(data)
                print("jsonDATA marking period list==",json)
                
                
                let option =  Options()
                for item in json["getMarkingPeriodView"].arrayValue {
                    
                    var text = item["text"].stringValue
                    print("text===",text)
                    var value = item["value"].stringValue
                    print("value===",value)
                    
                    option.arrText.append(text)
                    option.arrValue.append(value)
                    
                    self.dropdownMarkeingPeriod.optionArray = option.arrText
                    self.dropdownMarkeingPeriod.optionIds = option.ids
                    var id = option.ids
                    //dropdownMethods.checkMarkEnabled = false
                    self.dropdownMarkeingPeriod.didSelect{(selectedText , index , id) in
                        
                        self.container!.segueIdentifierReceivedFromParent("SegueLatterGrade")
                        self.viewHeader.isHidden = false
                        
                        let textValue = option.arrValue[index]
                        print("select textValue==",textValue)
                       
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
