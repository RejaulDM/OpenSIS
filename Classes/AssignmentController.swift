//
//  AssignmentController.swift
//  OpenSIS
//
//  Created by Rejaul on 2/9/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class AssignmentController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var  storeSchoolID = UserDefaults.standard.string(forKey: "Key_SchoolID") ?? ""
    var  storeEmail = UserDefaults.standard.string(forKey: "Key_Email") ?? ""
    var  storeTenantID = UserDefaults.standard.string(forKey: "Key_TenantId") ?? ""
    var  storeTenantName = UserDefaults.standard.string(forKey: "Key_TenantName") ?? ""
    var  storeToken = UserDefaults.standard.string(forKey: "Key_Token") ?? ""
    var  storeUserID = UserDefaults.standard.string(forKey: "KEY_USERID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_Name") ?? ""
    var storeAcademicYears = UserDefaults.standard.string(forKey: "Key_AcademicYears") ?? ""
    var stroreCourseSectionID = UserDefaults.standard.string(forKey: "Key_CourseSectionID") ?? ""
    var strorePeriodStartDate = UserDefaults.standard.string(forKey: "Key_PeriodStartDate") ?? ""
    var strorePeriodEndDate = UserDefaults.standard.string(forKey: "Key_PeriodEndDate") ?? ""
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
     var arrAssignment = [JSON]()
     var customView = UIView()
    
      var assignTypeID = ""
      var courseSecID = ""
    
   
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
        self.tableView.tableFooterView = UIView()
        
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        
        
        callAPIGetAllAssignment()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAssignment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AssignmentCell
        
        let item = arrAssignment[indexPath.row]
            cell.lblAssignmentName.text = item["title"].stringValue
        
        cell.ClickCellDelegateView = self
        cell.indexID = indexPath
        
        cell.ClickCellDelegateViewR = self
        cell.indexIDR = indexPath
        
        cell.btnSideMenu.addTarget(self, action: #selector(optionBtnClicked), for: .touchUpInside)
        
        //transparents table view cell
            cell.selectionStyle = .none
        return cell
    }
    
    
    @objc func optionBtnClicked(sender: UIButton){
        for view in customView.subviews {
            view.removeFromSuperview()
        }
        guard let cell = sender.superview?.superview as? AssignmentCell else {
            print("error in sender value")
            return
        }
        let selectedIndexPath = tableView.indexPath(for: cell)
        let frame = cell.btnSideMenu.superview!.convert(cell.btnSideMenu.frame, to: self.view)
        configurePopView(yPosition: Int(frame.maxY))
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.customView.removeFromSuperview()
        
        
    }
    func configurePopView(yPosition:Int){
        let screenSize: CGRect = UIScreen.main.bounds
        
        
        customView.frame = CGRect.init(x: Int(screenSize.width - 50)/2, y: yPosition, width: 200, height: 120)
        customView.backgroundColor = UIColor.white     //give color to the view
        // customView.center = self.view.center
        customView.layer.shadowColor = UIColor.gray.cgColor
        customView.layer.shadowOpacity = 0.3
        customView.layer.shadowOffset = CGSize.zero
        customView.layer.shadowRadius = 6
        
        let btnView:UIButton = UIButton(frame: CGRect(x: 10, y: 20, width: 170, height: 30))
        btnView.backgroundColor = .white
        btnView.setTitle("Edit Assignment Type", for: .normal)
        btnView.setTitleColor(.black, for: .normal)
        btnView.titleLabel?.font = .systemFont(ofSize: 15)
        btnView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        btnView.addTarget(self, action:#selector(self.pressedViewBtn), for: .touchUpInside)
        
        
        
        let btnAccept:UIButton = UIButton(frame: CGRect(x: 10, y: 60, width: 170, height: 30))
        btnAccept.backgroundColor = .white
        btnAccept.setTitle("Delete Assignment Type", for: .normal)
        btnAccept.titleLabel?.font = .systemFont(ofSize: 15)
        btnAccept.setTitleColor(.black, for: .normal)
        btnAccept.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        btnAccept.addTarget(self, action:#selector(self.pressedDeleteBtn), for: .touchUpInside)
        
        customView.addSubview(btnView)
        customView.addSubview(btnAccept)
        self.view.addSubview(customView)
    }
    
    @objc func pressedViewBtn() {
        self.customView.removeFromSuperview()
        print("Edit btn Clicked==")
        
        UserDefaults.standard.set("UPDATE", forKey: "Key_AssignType")
        let storyboard = UIStoryboard(name: "Classes", bundle: nil)
         let contollerName = storyboard.instantiateViewController(withIdentifier: "CreateNewAssignmentController")
         self.present(contollerName, animated: true, completion: nil)
        
    }
    
    @objc func pressedDeleteBtn() {
        self.customView.removeFromSuperview()
        print("accept btn Clicked")
        callAPIDeleteAssignment()
    }

    
    @IBAction func btnTappedCreateTemplate(_ sender: Any) {
        
        UserDefaults.standard.set("CREATE", forKey: "Key_AssignType")
        
        let storyboard = UIStoryboard(name: "Classes", bundle: nil)
         let contollerName = storyboard.instantiateViewController(withIdentifier: "CreateNewAssignmentController")
         self.present(contollerName, animated: true, completion: nil)
    }
    

}

extension AssignmentController:BtnRightOption {
    func ClickCellID(index: Int) {
        print("\(index) is clicked============ ")
        
        let item = arrAssignment[index]
            let assignmentTypeId = item["assignmentTypeId"].stringValue
        let courseSecId = item["courseSectionId"].stringValue
        
        assignTypeID = assignmentTypeId
        courseSecID = courseSecId
        print("\(assignTypeID)assignTypeID==","\(courseSecID)courseSecID==")
        
        let getassign = item["assignment"].arrayValue
        //let assvalue = getassign[0]
        
        let assignmentTitle = item["title"].stringValue
        let points = item["points"].stringValue
        let assignmentDate = item["assignmentDate"].stringValue
        let dueDate = item["dueDate"].stringValue
        let assignmentDescription = item["assignmentDescription"].stringValue
        let weightage = item["weightage"].stringValue
        
        
        UserDefaults.standard.set(weightage, forKey: "Key_Weightage")
        
        UserDefaults.standard.set(assignmentTitle, forKey: "Key_AssignmentTitle")
        UserDefaults.standard.set(points, forKey: "Key_Points")
        UserDefaults.standard.set(assignmentTypeId, forKey: "Key_AssignmentTypeId")
        UserDefaults.standard.set(assignmentDate, forKey: "Key_AssignmentDate")
        UserDefaults.standard.set(dueDate, forKey: "Key_DueDate")
        UserDefaults.standard.set(assignmentDescription, forKey: "Key_AssignmentDescription")
        
    }
}



extension AssignmentController:BtnRedirect {
    func ClickCellIDR(index: Int) {
        print("\(index) is clicked============ ")
        
        let item = arrAssignment[index]
        let assignmentTypeId = item["assignmentTypeId"].stringValue
        let courseSecId = item["courseSectionId"].stringValue
        
        assignTypeID = assignmentTypeId
        courseSecID = courseSecId
        print("\(assignTypeID)assignTypeID==","\(courseSecID)courseSecID==")
        
        UserDefaults.standard.set(item["title"].stringValue, forKey: "Key_AssignmentTitle")
        UserDefaults.standard.set(assignmentTypeId, forKey: "Key_AssignmentTypeId")
        
        UserDefaults.standard.set(index, forKey: "Key_IndexId")
        
        
        
        let storyboard = UIStoryboard(name: "Classes", bundle: nil)
         let contollerName = storyboard.instantiateViewController(withIdentifier: "InsideAssignmentCreateController")
         self.present(contollerName, animated: true, completion: nil)
        
    }
}

extension AssignmentController{
    
    // ====== All Assignmet Type
    
    func callAPIGetAllAssignment(){
        
        SVProgressHUD.show()
       
        let parameters = [
            "courseSectionId":stroreCourseSectionID,
                "_tenantName":storeTenantName,
                "_userName":storeName,
                "_token":storeToken,
                "tenantId":storeTenantID,
                "schoolId":storeSchoolID,
                "_academicYear": storeAcademicYears,
                "academicYear":storeAcademicYears,
                "markingPeriodStartDate":strorePeriodStartDate,
                "markingPeriodEndDate":strorePeriodEndDate
           ]as [String : Any];
        
        
        
        print("Param All Assignment Type==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StaffPortalAssignment/getAllAssignmentType"
        print("URL Assignment==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("Assignment Response==",response)
                let json = JSON(data)
                print("json Assignment==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false"{
                     let assignment = json["assignmentTypeList"].arrayValue
                     
                     self.arrAssignment = assignment
                     print("assignmentTypeList ==",self.arrAssignment)
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
    
    
   // ====== Delete Assignmet Type
    
    func callAPIDeleteAssignment(){
        
        SVProgressHUD.show()
       
        let parameters = [
            "assignmentType":[
                "assignmentTypeId":assignTypeID,
                "courseSectionId":courseSecID,
                "schoolId":storeSchoolID,
                "tenantId":storeTenantID
              ],
            "_tenantName":storeTenantName,
            "_userName":storeName,
            "_token":storeToken,
            "tenantId":storeTenantID,
            "schoolId":storeSchoolID
           ]as [String : Any];
        
        
        
        print("Param Assign Delete==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StaffPortalAssignment/deleteAssignmentType"
        print("URL Assign Delete==",urlString)
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {response in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                print("Assign Delete Response==",response)
                let json = JSON(data)
                print("json Assign Delete==",json)
                
                let status = json["_failure"].stringValue
                let message = json["_message"].stringValue
                
                 if status == "false" || status == "0" {
                     let assignment = json["assignmentTypeList"].arrayValue
                     
                     
                     self.displayMessage(userMessage:message)
                     
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
   
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Are you sure?", message: "You are about to delete.", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
                
                // Code in this block will trigger when OK button tapped.
                print("Ok button tapped");
                
                self.callAPIGetAllAssignment()
                
            }
            alertController.addAction(OKAction)
            // Create Cancel button
            let cancelAction = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
                print("Cancel button tapped");
            }
            alertController.addAction(cancelAction)
           
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
}




class SelectedAssignment {
    
    var assignmentTitle:String?
    var assignmentDescription:String?
    var assignmentTypeId:String?
    var assignmentId:String?
    var courseSectionId:String?
    var points:String?
    var assignmentDate:String?
    var dueDate:String?
    var staffId:String?
    
    init(assignmentTitle: String?,assignmentDescription:String?, assignmentTypeId: String?, assignmentId: String?, courseSectionId: String?,points:String?,assignmentDate:String,dueDate:String?,staffId:String?) {
        
        self.assignmentTitle = assignmentTitle
        self.assignmentDescription = assignmentDescription
        self.assignmentTypeId = assignmentTypeId
        self.assignmentId = assignmentId
        self.courseSectionId = courseSectionId
        self.points = points
        self.assignmentDate = assignmentDate
        self.dueDate = dueDate
        self.staffId = staffId
        
    }
}

