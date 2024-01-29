//
//  StudentController.swift
//  OpenSIS
//
//  Created by Rejaul on 1/20/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import  MessageUI

class StudentController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var storeCourseSectionID = UserDefaults.standard.string(forKey: "Key_CourseSectionID") ?? ""
    
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    var arrStudentList = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
        self.tableView.tableFooterView = UIView()
        
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        tableView.reloadData()
        
        callAPIGetStudentList()
        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStudentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudentCell
        
        let item = arrStudentList[indexPath.row]
        let firstname = item["firstGivenName"].stringValue
        let lstname = item["lastFamilyName"].stringValue
        cell.lblName.text = lstname + ", " + firstname
        cell.lblID.text = "ID :" + item["studentInternalId"].stringValue
        cell.lblAltID.text = "Alt ID :" +  item["alternateId"].stringValue
        cell.lblGrade.text = item["gradeLevel"].stringValue
        
        let imgPath = item["studentPhoto"].stringValue
        if imgPath == "" {
            print("error with base64String")
            
            //icon.image = iconEmpt
            } else {
                let decodedData = NSData(base64Encoded: imgPath, options: [])
                if let data = decodedData {
                    let decodedimage = UIImage(data: data as Data)
                    cell.imgProfile.image = decodedimage
                    } else {
                        print("error with decodedData")
                    }
                }
        
        
        cell.ClickCellDelegateEmpInFile = self
        cell.indexIDEmpInFile = indexPath

        
        cell.ClickCellDelegateEmpOutFile = self
        cell.indexIDEmpOutFile = indexPath
        
       /* let imgPath = item.ProductImageName
        let InImgURL = imgPath
        let urlStringImg = InImgURL!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        cell.imgItem.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgItem.sd_setImage(with: URL(string: urlStringImg), placeholderImage: UIImage(named: "")) */
        
        
        //transparents table view cell
            cell.selectionStyle = .none
        return cell
    }
    
    
}


extension StudentController: EmpCall {
    func ClickCellInFView(index: Int) {
        print("\(index) Tapped Call==")
        
        let dict = arrStudentList[index]
        let getNo = dict["phoneNumber"].stringValue
        print("getNo===",getNo)
        
        callNumber(phoneNumber: getNo)
        
    }
    
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension StudentController:EmpMail {
    func ClickCellOutFView(index: Int) {
        print("\(index) Tapped Mail==")
        
        if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([""])
                mail.setMessageBody("<p>Sent E-mail!</p>", isHTML: true)
                present(mail, animated: true)
            }
        
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}






extension StudentController{
    
    
    // ====== All Schoils Lists
    
    func callAPIGetStudentList(){
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
        print("Param Student==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StudentSchedule/getStudentListByCourseSection"
        print("URL Student==",urlString)
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
                print("json Student==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let allSchool = json["scheduleStudentForView"].arrayValue
                     self.arrStudentList = allSchool
                     print("arrStudentList==",self.arrStudentList)
                     
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
