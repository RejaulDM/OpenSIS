//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import SDWebImage

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController{
    

    @IBOutlet var btnCloseMenuOverlay : UIButton!

    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
    *  Menu button which was tapped to display the menu
    */
    var btnMenu : UIButton!
    
    /**
    *  Delegate of the MenuVC
    */
    var delegate : SlideMenuDelegate?
    
 
    @IBOutlet weak var viewSide: UIView!

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var textName: UILabel!
   
    @IBOutlet weak var lblProType: UILabel!
    
    var indexID = 0
    
    var strCustomerId = UserDefaults.standard.string(forKey: "KeyCustomerID") ?? ""
    var  storeName = UserDefaults.standard.string(forKey: "Key_FullName") ?? ""
    
    var storeUserPhoto = UserDefaults.standard.string(forKey: "Key_UserPhoto") ?? ""
    
    let iconEmpt = UIImage(named: "student") as UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textName.text = storeName
        
       imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.clipsToBounds = true
        
        imgProfile.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        imgProfile.layer.borderWidth = 1
        
        view.backgroundColor = UIColor.clear
   
        view.isOpaque = false

        
        lblProType.layer.cornerRadius = 8
        lblProType.layer.borderWidth = 1
        lblProType.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lblProType.layer.masksToBounds = true
        
        let imgPath = storeUserPhoto
        if imgPath == "" {
            print("error with base64String")
            
            imgProfile.image = iconEmpt
            } else {
                let decodedData = NSData(base64Encoded: imgPath, options: [])
                if let data = decodedData {
                    let decodedimage = UIImage(data: data as Data)
                    
                    imgProfile.image = decodedimage
                    } else {
                        print("error with decodedData")
                    }
                }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
      self.btnCloseMenuOverlay.isHidden = false
        
        
    }
    
    
    @IBAction func btnBack(_ button: UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParent()
        })
    }
    
    
    
    @IBAction func btnTappedDash(_ sender: Any) {
   
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardNav")
        self.present(controller, animated: true, completion: nil)
        self.viewSide.isHidden = true
    }
   
    
    @IBAction func btnTappedSchools(_ sender: Any) {
   
        let storyBoard = UIStoryboard(name: "Schools", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SchoolsController")
        self.present(controller, animated: true, completion: nil)
        self.viewSide.isHidden = true
    }
    // AboutUs
    
    
    @IBAction func btnTappedClasses(_ sender: Any) {
    
        let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ClassesController")
        self.present(controller, animated: true, completion: nil)
        self.viewSide.isHidden = true
    }
    
    //FAQs
    @IBAction func btnTapCalendar(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Calendar", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "CalendarController")
        self.present(controller, animated: true, completion: nil)
        self.viewSide.isHidden = true
    }
    
   
    @IBAction func btnTapStudent(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Students", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "AllStudentsController")
        self.present(controller, animated: true, completion: nil)
        self.viewSide.isHidden = true
    }
    
  
    @IBAction func BtnTapMarkingPeriods(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "MarkingPeriods", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "MarkingPeriodsController")
        self.present(controller, animated: true, completion: nil)
        self.viewSide.isHidden = true
    }
    
    @IBAction func btnTapSchedule(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Schedule", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ScheduleController")
        self.present(controller, animated: true, completion: nil)
        self.viewSide.isHidden = true
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        
        let alertController = UIAlertController(title: "", message: "Logout Successfully!", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
            
            UserDefaults.standard.removeObject(forKey: "key_loginID")
            
            UserDefaults.standard.removeObject(forKey: "key_password")
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let contollerName = storyboard.instantiateViewController(withIdentifier: "Login1")
            self.present(contollerName, animated: true, completion: nil)
            print("Ok button tapped=====");
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
 
    
    
    @IBAction func onCloseMenuClick(_ button: UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParent()
        })
    }
    
    
    
    
}
