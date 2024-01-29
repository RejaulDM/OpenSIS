//
//  AllStudentsController.swift
//  OpenSIS
//
//  Created by Rejaul on 1/7/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON


class AllStudentsController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SelectSchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
    var arrAllStudentView = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
        self.tableView.tableFooterView = UIView()
        
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        callAPIGetStudents()
        
        // Do any additional setup after loading the view.
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllStudentView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllStudentsCell
        
        let item = arrAllStudentView[indexPath.row]
        
        cell.lblID.text = item["studentInternalId"].stringValue
        
        let lastFamilyName = item["lastFamilyName"].stringValue
        let firstGivenName = item["firstGivenName"].stringValue
        cell.lblStudentName.text = lastFamilyName + " " + firstGivenName
        
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



extension AllStudentsController{
    
    
    // ====== All Students
    
    func callAPIGetStudents(){
        
        SVProgressHUD.show()
        
        let parameters = [
            "pageNumber":1,
            "_pageSize":10,
            "sortingModel":nil,
            "filterParams":[],
            "courseSectionIds":[],
            "staffId":storeUserID,
            "academicYear":storeAcademicYears,
            "_tenantName": storeTenantName,
            "_userName": storeName,
            "_token": storeToken,
            "tenantId": storeTenantID,
            "schoolId": storeSchoolID
          ]as [String : Any];
        
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
                print("Student Response===",response)
                let json = JSON(data)
                print("json Student==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let StudentForView = json["scheduleStudentForView"].arrayValue
                     print("StudentForView==",StudentForView)
                     self.arrAllStudentView = StudentForView
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
