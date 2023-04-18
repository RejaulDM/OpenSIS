//
//  ClassOverviewController.swift
//  OpenSIS
//
//  Created by Rejaul on 12/5/22.
//

import UIKit

struct MenuItem {
    var itemName : String
}

class ClassOverviewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    
    
    @IBOutlet weak var lblHeadreName: UILabel!
    
    
    
    var headerMenuItem = [
        MenuItem(itemName: "Overview"),
        MenuItem(itemName: "Student"),
        MenuItem(itemName: "Attendance"),
        MenuItem(itemName: "Gradebook Configuartion"),
        MenuItem(itemName: "Assignments"),
        MenuItem(itemName: "Grades"),
        
    ]
    
    var selectedIndex = Int ()
    
    var container: ClassesContainer!

    
    var  storeGradePage = UserDefaults.standard.string(forKey: "Key_GradePage") ?? ""
    
    var  storeCourseName = UserDefaults.standard.string(forKey: "Key_CourseName") ?? ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeadreName.text = storeCourseName
        
        self.headerCollectionView.delegate = self
        self.headerCollectionView.dataSource = self
        
        if storeGradePage == "Grade"{
            container!.segueIdentifierReceivedFromParent("GradeSegue")
            UserDefaults.standard.set(" ", forKey: "Key_GradePage")
        }
       else if storeGradePage == "Assignment"{
            container!.segueIdentifierReceivedFromParent("AssignmentSegue")
            UserDefaults.standard.set(" ", forKey: "Key_GradePage")
        }
        else if storeGradePage == "AssignmentInside"{
            container!.segueIdentifierReceivedFromParent("AssignmentSegue")
            UserDefaults.standard.set(" ", forKey: "Key_GradePage")
        }
        else{
            
            container!.segueIdentifierReceivedFromParent("OverviewSegue")
        }
        
        self.headerCollectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func btnTappedBack(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardNav")
        self.present(controller, animated: true, completion: nil)
    }
    
}

extension ClassOverviewController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        headerMenuItem.count
        
     }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassOverviewCell", for: indexPath) as! ClassOverviewCell
             
            let item = headerMenuItem[indexPath.row]
        cell.lblTypeName.text = item.itemName
        
        cell.backView.layer.cornerRadius = 25
        cell.backView.layer.borderWidth = 1
        cell.backView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        if selectedIndex == indexPath.row
        {
        cell.backView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.lblTypeName.textColor = #colorLiteral(red: 0, green: 0.1347569898, blue: 0.2382595948, alpha: 1)
            
        }
        else
        {
        cell.backView.backgroundColor = #colorLiteral(red: 0, green: 0.1347569898, blue: 0.2382595948, alpha: 1)
        cell.lblTypeName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        var  Key_IndexId = UserDefaults.standard.integer(forKey: "Key_IndexId")
        print("cat id match ====",Key_IndexId)
        
        
        if indexPath.row == Key_IndexId{
            cell.backView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.lblTypeName.textColor = #colorLiteral(red: 0, green: 0.1347569898, blue: 0.2382595948, alpha: 1)
        }else{
            cell.backView.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
            cell.lblTypeName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
         return cell
   }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = headerMenuItem[indexPath.row]
        let getname = item.itemName
        UserDefaults.standard.set(indexPath.row, forKey: "Key_IndexId")
        
        if(indexPath.row == 0){
           /* if let cell = collectionView.cellForItem(at: indexPath as IndexPath) as? ClassOverviewCell{
                
                cell.backView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.lblTypeName.textColor = #colorLiteral(red: 0, green: 0.1347569898, blue: 0.2382595948, alpha: 1)
                
            }
            let cell = collectionView.cellForItem(at: [0, 0])
            
            
            let cell1 = collectionView.cellForItem(at: [0, 1])
            cell1?.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            
            let cell2 = collectionView.cellForItem(at: [0, 2])
            cell2?.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.8039215686, blue: 0.2549019608, alpha: 1)
            
            let cell3 = collectionView.cellForItem(at: [0, 3])
            cell3?.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 0.911922089)
            
            let cell4 = collectionView.cellForItem(at: [0, 4])
            cell4?.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            
            let cell5 = collectionView.cellForItem(at: [0, 5])
            cell5?.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)*/
            
            container!.segueIdentifierReceivedFromParent("OverviewSegue")
            self.headerCollectionView.reloadData()
        }
        
       else if(indexPath.row == 1){
           
           /* let cell = collectionView.cellForItem(at: [0, 0])
            cell?.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
            let cell1 = collectionView.cellForItem(at: [0, 1])
            cell1?.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            
            let cell2 = collectionView.cellForItem(at: [0, 2])
            cell2?.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.8039215686, blue: 0.2549019608, alpha: 1)
            
            let cell3 = collectionView.cellForItem(at: [0, 3])
            cell3?.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 0.911922089)
            
            let cell4 = collectionView.cellForItem(at: [0, 4])
            cell4?.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            
            let cell5 = collectionView.cellForItem(at: [0, 5])
            cell5?.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1) */
            
            container!.segueIdentifierReceivedFromParent("StudentSegue")
           self.headerCollectionView.reloadData()
        }
        else if(indexPath.row == 2){
             
            /* let cell = collectionView.cellForItem(at: [0, 0])
             cell?.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
             
             let cell1 = collectionView.cellForItem(at: [0, 1])
             cell1?.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
             
             let cell2 = collectionView.cellForItem(at: [0, 2])
             cell2?.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.8039215686, blue: 0.2549019608, alpha: 1)
             
             let cell3 = collectionView.cellForItem(at: [0, 3])
             cell3?.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 0.911922089)
             
             let cell4 = collectionView.cellForItem(at: [0, 4])
             cell4?.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
             
             let cell5 = collectionView.cellForItem(at: [0, 5])
             cell5?.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1) */
             
             container!.segueIdentifierReceivedFromParent("AttendanceSegue")
            self.headerCollectionView.reloadData()
         }
        else if(indexPath.row == 3){
             
            /* let cell = collectionView.cellForItem(at: [0, 0])
             cell?.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
             
             let cell1 = collectionView.cellForItem(at: [0, 1])
             cell1?.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
             
             let cell2 = collectionView.cellForItem(at: [0, 2])
             cell2?.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.8039215686, blue: 0.2549019608, alpha: 1)
             
             let cell3 = collectionView.cellForItem(at: [0, 3])
             cell3?.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 0.911922089)
             
             let cell4 = collectionView.cellForItem(at: [0, 4])
             cell4?.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
             
             let cell5 = collectionView.cellForItem(at: [0, 5])
             cell5?.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1) */
             
             container!.segueIdentifierReceivedFromParent("GreadeBookSegue")
            self.headerCollectionView.reloadData()
         }
        else if(indexPath.row == 4){
             
            /* let cell = collectionView.cellForItem(at: [0, 0])
             cell?.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
             
             let cell1 = collectionView.cellForItem(at: [0, 1])
             cell1?.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
             
             let cell2 = collectionView.cellForItem(at: [0, 2])
             cell2?.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.8039215686, blue: 0.2549019608, alpha: 1)
             
             let cell3 = collectionView.cellForItem(at: [0, 3])
             cell3?.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 0.911922089)
             
             let cell4 = collectionView.cellForItem(at: [0, 4])
             cell4?.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
             
             let cell5 = collectionView.cellForItem(at: [0, 5])
             cell5?.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1) */
             
             container!.segueIdentifierReceivedFromParent("AssignmentSegue")
            self.headerCollectionView.reloadData()
         }
        else if(indexPath.row == 5){
             
            /* let cell = collectionView.cellForItem(at: [0, 0])
             cell?.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
             
             let cell1 = collectionView.cellForItem(at: [0, 1])
             cell1?.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
             
             let cell2 = collectionView.cellForItem(at: [0, 2])
             cell2?.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.8039215686, blue: 0.2549019608, alpha: 1)
             
             let cell3 = collectionView.cellForItem(at: [0, 3])
             cell3?.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 0.911922089)
             
             let cell4 = collectionView.cellForItem(at: [0, 4])
             cell4?.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
             
             let cell5 = collectionView.cellForItem(at: [0, 5])
             cell5?.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1) */
             
             container!.segueIdentifierReceivedFromParent("GradeSegue")
            self.headerCollectionView.reloadData()
         }
       
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClassesSegua"{
            container = segue.destination as? ClassesContainer
            //For adding animation to the transition of containerviews you can use container's object property
            // animationDurationWithOptions and pass in the time duration and transition animation option as a tuple
            // Animations that can be used
            // .transitionFlipFromLeft, .transitionFlipFromRight, .transitionCurlUp
            // .transitionCurlDown, .transitionCrossDissolve, .transitionFlipFromTop
            container.animationDurationWithOptions = (0.5, .transitionCrossDissolve)
        }
    }
    
}
