//
//  InsideAssignmentCreateController.swift
//  OpenSIS
//
//  Created by Rejaul on 2/17/23.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON


class InsideAssignmentCreateController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {

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
    
    var stroreAssignmentTitle = UserDefaults.standard.string(forKey: "Key_AssignmentTitle") ?? ""
    
    var  stroreIndexId = UserDefaults.standard.string(forKey: "Key_IndexId") ?? ""
    
    let BaseURL = UserDefaults.standard.string(forKey: "Key_BaseURL") ?? ""
    
     var arrAssignment = [JSON]()
    var customView = UIView()
    
    var assignTypeID = ""
    var courseSecID = ""
    var assignmentID = ""

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblHeaderName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeaderName.text! = stroreAssignmentTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
        self.tableView.tableFooterView = UIView()
        
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        tableView.reloadData()
        
        callAPIGetAllAssignment()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnTappedBack(_ sender: Any) {
        
        UserDefaults.standard.set("AssignmentInside", forKey: "Key_GradePage")
        
        let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ClassOverviewNav")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func btnTappedCreateAssignmentType(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "CreateNewInsideAssignmentController")
        self.present(controller, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectAllAssignment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InsideAssignmentCreateCell
        
        let item = selectAllAssignment[indexPath.row]
        cell.lblAssignMentName.text = item.assignmentTitle
        cell.lblPoints.text = item.points
        
        let sdate = item.assignmentDate!
        let edate = item.dueDate!
        
        let start = sdate.components(separatedBy: "T")
        let getStart : String = start[0]
        let end = edate.components(separatedBy: "T")
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
        
        cell.lblAssignmentDate.text = resultString
        cell.lblDueDate.text = resultStringend
        
        
        cell.ClickCellDelegateView = self
        cell.indexID = indexPath
        
        
        
        cell.btnActionRightOption.addTarget(self, action: #selector(optionBtnClicked), for: .touchUpInside)
        
        //transparents table view cell
            cell.selectionStyle = .none
        return cell
    }
    
    
    @objc func optionBtnClicked(sender: UIButton){
        for view in customView.subviews {
            view.removeFromSuperview()
        }
        guard let cell = sender.superview?.superview?.superview as? InsideAssignmentCreateCell else {
            print("error in sender value")
            return
        }
        let selectedIndexPath = tableView.indexPath(for: cell)
        let frame = cell.btnActionRightOption.superview!.convert(cell.btnActionRightOption.frame, to: self.view)
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
        btnView.setTitle("Edit Assignment", for: .normal)
        btnView.setTitleColor(.black, for: .normal)
        btnView.titleLabel?.font = .systemFont(ofSize: 15)
        btnView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        btnView.addTarget(self, action:#selector(self.pressedViewBtn), for: .touchUpInside)
        
        
        
        let btnAccept:UIButton = UIButton(frame: CGRect(x: 10, y: 60, width: 170, height: 30))
        btnAccept.backgroundColor = .white
        btnAccept.setTitle("Delete Assignment", for: .normal)
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

    
    
}

extension InsideAssignmentCreateController:BtnRightOptionAss {
    func ClickCellID(index: Int) {
        print("\(index) is clicked============ ")
        
        let item = arrAssignment[index]
        let item1 = selectAllAssignment[index]
        assignmentID = item1.assignmentId!
        assignTypeID = item1.assignmentTypeId!
        courseSecID = item1.courseSectionId!
        print("assignTypeID==\(assignTypeID)","courseSecID==\(courseSecID)","assignmentID==\(assignmentID)")
        
        //let getassign = item["assignment"].arrayValue
        //let assvalue = getassign[0]
        
        let assignmentTitle = item1.assignmentTitle
        let points = item1.points
        let assignmentDate = item1.assignmentDate
        let dueDate = item1.dueDate
        let assignmentDescription = item1.assignmentDescription
        let staffId = item1.staffId
        let weightage = item["weightage"].stringValue
        
        UserDefaults.standard.set(assignmentID, forKey: "Key_assignmentID")
        UserDefaults.standard.set(weightage, forKey: "Key_Weightage")
        UserDefaults.standard.set(assignmentTitle, forKey: "Key_AssignmentTitle")
        UserDefaults.standard.set(points, forKey: "Key_Points")
        UserDefaults.standard.set(assignTypeID, forKey: "Key_AssignmentTypeId")
        UserDefaults.standard.set(assignmentDate, forKey: "Key_AssignmentDate")
        UserDefaults.standard.set(dueDate, forKey: "Key_DueDate")
        UserDefaults.standard.set(assignmentDescription, forKey: "Key_AssignmentDescription")
        UserDefaults.standard.set(staffId, forKey: "Key_staffId")
        
    }
}


extension InsideAssignmentCreateController{
    
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
                "academicYear":storeAcademicYears,
            "_academicYear":storeAcademicYears,
                "markingPeriodStartDate":strorePeriodStartDate,
                "markingPeriodEndDate":strorePeriodEndDate
           ]as [String : Any];
        print("Param Assignment==",parameters)
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
                selectAllAssignment.removeAll()
                 if status == "false"{
                     
                     let assignment = json["assignmentTypeList"].arrayValue
                     
                     self.arrAssignment = assignment
                     print("assignmentTypeList ==",self.arrAssignment)
                     let assvalue = assignment[Int(self.stroreIndexId)!]
                     let getassign = assvalue["assignment"].arrayValue
                     print("getassign===",getassign)
                     
                     
                     for assvalue in getassign{
                         
                         let assignmentDate = assvalue["assignmentDate"].stringValue
                         let assignmentDescription = assvalue["assignmentDescription"].stringValue
                         let assignmentId = assvalue["assignmentId"].stringValue
                         let assignmentTitle = assvalue["assignmentTitle"].stringValue
                         let assignTypeId = assvalue["assignmentTypeId"].stringValue
                         let createdBy = assvalue["createdBy"].stringValue
                         let createdOn = assvalue["createdOn"].stringValue
                         let dueDate = assvalue["dueDate"].stringValue
                         let point = assvalue["points"].stringValue
                         let staffid = assvalue["staffId"].stringValue
                         let courseSecId = assvalue["courseSectionId"].stringValue
                         
                         print("assignmentId==",assignmentId)
                         print("assignTypeId===",assignTypeId)
                         selectAllAssignment.append(SelectedAssignment(assignmentTitle: String() + assignmentTitle, assignmentDescription: String() + assignmentDescription, assignmentTypeId: String() + assignTypeId, assignmentId: String() + assignmentId, courseSectionId: String() + courseSecId, points: String() + point, assignmentDate: String() + assignmentDate, dueDate: String() + dueDate, staffId: String() + staffid))
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
    
    
   // ====== Delete Assignmet Type
    
    func callAPIDeleteAssignment(){
        
        SVProgressHUD.show()
       
        let parameters = [
            "assignment":[
                "courseSectionId":courseSecID,
                "assignmentId":assignmentID,
                "assignmentTypeId":assignTypeID,
                "schoolId":storeSchoolID,
                "tenantId":storeTenantID
                ],
                "_tenantName":storeTenantName,
                "_userName":storeName,
                "_token":storeToken,
                "_academicYear":storeAcademicYears,
                "tenantId":storeTenantID,
                "schoolId":storeSchoolID
           ]as [String : Any];
        
        print("Param Assign Delete==",parameters)
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let urlString = BaseURL + "StaffPortalAssignment/deleteAssignment"
        //StaffPortalAssignment/deleteAssignment
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
