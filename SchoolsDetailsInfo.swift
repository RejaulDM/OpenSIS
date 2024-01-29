//
//  SchoolsDetailsInfo.swift
//  OpenSIS
//
//  Created by Rejaul on 1/4/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SchoolsDetailsInfo: UIViewController {
    
    
    @IBOutlet weak var lblHeaderName: UILabel!
    
    
    @IBOutlet weak var btnTitleGeneralInfo: UIButton!
    
    @IBOutlet weak var lblWashInfo: UIButton!
    
    @IBOutlet weak var lblSchoolName: UILabel!
    @IBOutlet weak var lblAlternateName: UILabel!
    @IBOutlet weak var lblSchoolID: UILabel!
    @IBOutlet weak var lblSchoolAlternateID: UILabel!
    @IBOutlet weak var lblStateID: UILabel!
    @IBOutlet weak var lblDistrictID: UILabel!
    @IBOutlet weak var lblSchoolLevel: UILabel!
    @IBOutlet weak var lblSchoolClassification: UILabel!
    @IBOutlet weak var lblAffiliation: UILabel!
    @IBOutlet weak var lblAssociation: UILabel!
    @IBOutlet weak var lblLowestGradeLevel: UILabel!
    @IBOutlet weak var lblHighestGradeLevel: UILabel!
    @IBOutlet weak var lblDateSchoolFirstStarted: UILabel!
    @IBOutlet weak var lblLocaleCode: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblInternet: UILabel!
    @IBOutlet weak var lblElectricity: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    
    @IBOutlet weak var lblStreetAddress1: UILabel!
    @IBOutlet weak var lblStreetAddress2: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblCounty: UILabel!
    @IBOutlet weak var lblDivision: UILabel!
    @IBOutlet weak var lblStateRegionProvince: UILabel!
    @IBOutlet weak var lblDistrict: UILabel!
    @IBOutlet weak var lblZipPostalCode: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblLatitudeLongitude: UILabel!
    @IBOutlet weak var lblPrincipal: UILabel!
    @IBOutlet weak var lblAssistantPrincipal: UILabel!
    @IBOutlet weak var lblTelephone: UILabel!
    @IBOutlet weak var lblFax: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblTwitter: UILabel!
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var lblInstagram: UILabel!
    @IBOutlet weak var lblYoutube: UILabel!
    @IBOutlet weak var lblLinkedIn: UILabel!
    
    
    
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SelectSchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var  storeSchoolName = UserDefaults.standard.string(forKey: "Key_SchoolName") ?? ""
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("storeSchoolName===",storeSchoolName)
        lblHeaderName.text = storeSchoolName
        
        btnTitleGeneralInfo.layer.cornerRadius = 8
        lblWashInfo.layer.cornerRadius = 8
        
        callAPIGetSchoolsDetails()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnTappedWashInfo(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Schools", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SchoolsDetailsWashInfo")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Schools", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SchoolsController")
        self.present(controller, animated: true, completion: nil)
    }
    
}


extension SchoolsDetailsInfo{
    
    
    // ====== All Schoils Details
    
    func callAPIGetSchoolsDetails(){
        
        SVProgressHUD.show()
        
        let parameters = [
            "schoolMaster": [
                "schoolDetail": [
                    [
                        "id": 0,
                        "status": true,
                        "tenantId": "1e93c7bf-0fae-42bb-9e09-a1cedc8c0355",
                        "schoolId": 51
                    ]
                ],
                "latitude": nil,
                "longitude": nil,
                "schoolId": storeSchoolID,
                "tenantId": storeTenantID
            ],
            "selectedCategoryId": 0,
            "_tenantName": storeTenantName,
            "_userName": storeName,
            "_token": storeToken,
            "tenantId": storeTenantID,
            "schoolId": storeSchoolID
        ]as [String : Any];
        
        
        print("Param Schools Details==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "School/viewSchool"
        print("URL Schools Details==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("SchoolsDetails Response===",response)
                let json = JSON(data)
                print("json Schools Details==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let MasterDetails = json["schoolMaster"].dictionaryValue
                     print("SchoolMasterDetails==",MasterDetails)
                     
                     self.lblSchoolName.text = MasterDetails["schoolName"]?.stringValue
                     self.lblAlternateName.text = MasterDetails["alternateName"]?.stringValue
                     self.lblSchoolID.text = MasterDetails["schoolInternalId"]?.stringValue
                     self.lblSchoolAlternateID.text = MasterDetails[""]?.stringValue
                     self.lblStateID.text = MasterDetails["schoolStateId"]?.stringValue
                     self.lblDistrictID.text = MasterDetails["schoolDistrictId"]?.stringValue
                     self.lblSchoolLevel.text = MasterDetails["schoolLevel"]?.stringValue
                     self.lblSchoolClassification.text = MasterDetails["schoolClassification"]?.stringValue
                     
                     let SchoolDetails1 = json["schoolMaster"].dictionaryValue
                     print("SchoolDetails==",SchoolDetails1)
                     let schooldetailObj = SchoolDetails1["schoolDetail"]?.arrayValue
                     
                     let SchoolDetails = schooldetailObj?[0]
                     
                     self.lblAffiliation.text = SchoolDetails?["affiliation"].stringValue
                     self.lblAssociation.text = SchoolDetails?["associations"].stringValue
                     self.lblLowestGradeLevel.text = SchoolDetails?["lowestGradeLevel"].stringValue
                     self.lblHighestGradeLevel.text = SchoolDetails?["highestGradeLevel"].stringValue
                     self.lblDateSchoolFirstStarted.text = SchoolDetails?["dateSchoolOpened"].stringValue
                     self.lblLocaleCode.text = SchoolDetails?["locale"].stringValue
                     self.lblGender.text = SchoolDetails?["gender"].stringValue
                     
                     let internet = SchoolDetails?["internet"].stringValue
                     if internet == "true"{
                         self.lblInternet.text = "Yes"
                     }else{
                         self.lblInternet.text = "-"
                     }
                     self.lblElectricity.text = SchoolDetails?["electricity"].stringValue
                     
                     let ststus = SchoolDetails?["status"].stringValue
                     if ststus == "true"{
                         self.lblStatus.text = "Active"
                     }else{
                         self.lblStatus.text = ""
                     }
                     
                     self.lblStreetAddress1.text = MasterDetails["streetAddress1"]?.stringValue
                     self.lblStreetAddress2.text = MasterDetails["streetAddress2"]?.stringValue
                     self.lblCity.text = MasterDetails["city"]?.stringValue
                     self.lblCounty.text = MasterDetails["county"]?.stringValue
                     self.lblDivision.text = MasterDetails["division"]?.stringValue
                     self.lblStateRegionProvince.text = MasterDetails["state"]?.stringValue
                     self.lblDistrict.text = MasterDetails["district"]?.stringValue
                     self.lblZipPostalCode.text = MasterDetails["zip"]?.stringValue
                     self.lblCountry.text = MasterDetails["country"]?.stringValue
                     self.lblLatitudeLongitude.text = (MasterDetails["latitude"]?.stringValue ?? "-") + "," + (MasterDetails["longitude"]?.stringValue ?? "-")
                     
                     self.lblPrincipal.text = SchoolDetails?["nameOfPrincipal"].stringValue
                     self.lblAssistantPrincipal.text = SchoolDetails?["nameOfAssistantPrincipal"].stringValue
                     self.lblTelephone.text = SchoolDetails?["telephone"].stringValue
                     self.lblFax.text = SchoolDetails?["fax"].stringValue
                     self.lblWebsite.text = SchoolDetails?["website"].stringValue
                     self.lblEmail.text = SchoolDetails?["email"].stringValue
                     self.lblTwitter.text = SchoolDetails?["twitter"].stringValue
                     self.lblFacebook.text = SchoolDetails?["facebook"].stringValue
                     self.lblInstagram.text = SchoolDetails?["instagram"].stringValue
                     self.lblYoutube.text = SchoolDetails?["youtube"].stringValue
                     self.lblLinkedIn.text = SchoolDetails?["linkedIn"].stringValue
                     
                     UserDefaults.standard.set(SchoolDetails?["runningWater"].stringValue, forKey: "Key_runningWater")
                     UserDefaults.standard.set(SchoolDetails?["mainSourceOfDrinkingWater"].stringValue, forKey: "Key_SourceOfDrinkingWater")
                     UserDefaults.standard.set(SchoolDetails?["currentlyAvailable"].stringValue, forKey: "Key_currentlyAvailable")
                     UserDefaults.standard.set(SchoolDetails?["handwashingAvailable"].stringValue, forKey: "Key_handwashingAvailable")
                     UserDefaults.standard.set(SchoolDetails?["soapAndWaterAvailable"].stringValue, forKey: "Key_soapAndWaterAvailable")
                     UserDefaults.standard.set(SchoolDetails?["hygeneEducation"].stringValue, forKey: "Key_hygeneEducation")
                     
                     UserDefaults.standard.set(SchoolDetails?["femaleToiletType"].stringValue, forKey: "Key_femaleToiletType")
                     UserDefaults.standard.set(SchoolDetails?["totalFemaleToilets"].stringValue, forKey: "Key_totalFemaleToilets")
                     UserDefaults.standard.set(SchoolDetails?["totalFemaleToiletsUsable"].stringValue, forKey: "Key_totalFemaleToiletsUsable")
                     UserDefaults.standard.set(SchoolDetails?["femaleToiletAccessibility"].stringValue, forKey: "Key_femaleToiletAccessibility")
                     
                     
                     UserDefaults.standard.set(SchoolDetails?["maleToiletType"].stringValue, forKey: "Key_maleToiletType")
                     UserDefaults.standard.set(SchoolDetails?["totalMaleToilets"].stringValue, forKey: "Key_totalMaleToilets")
                     UserDefaults.standard.set(SchoolDetails?["totalMaleToiletsUsable"].stringValue, forKey: "Key_totalMaleToiletsUsable")
                     UserDefaults.standard.set(SchoolDetails?["maleToiletAccessibility"].stringValue, forKey: "Key_maleToiletAccessibility")
                     
                     UserDefaults.standard.set(SchoolDetails?["comonToiletType"].stringValue, forKey: "Key_comonToiletType")
                     UserDefaults.standard.set(SchoolDetails?["totalCommonToilets"].stringValue, forKey: "Key_totalCommonToilets")
                     UserDefaults.standard.set(SchoolDetails?["totalCommonToiletsUsable"].stringValue, forKey: "Key_totalCommonToiletsUsable")
                     UserDefaults.standard.set(SchoolDetails?["commonToiletAccessibility"].stringValue, forKey: "Key_commonToiletAccessibility")
                     
                     
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
