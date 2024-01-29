//
//  AttendanceTextRemarks.swift
//  OpenSIS
//
//  Created by Rejaul on 1/30/23.
//

import UIKit

class AttendanceTextRemarks: UIViewController {
    
    @IBOutlet weak var textRemarks: UITextView!
    
    @IBOutlet weak var viewBack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textRemarks.layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        textRemarks.layer.borderWidth = 1
        
        viewBack.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        viewBack.layer.borderWidth = 1

        // Do any additional setup after loading the view.
    }

    @IBAction func btnTappedCancel(_ sender: Any) {
        
        self.dismiss(animated: true){
           
        }
        
    }
    
    @IBAction func btnTappedSubmit(_ sender: Any) {
        
        let getRemark = textRemarks.text!
        
        UserDefaults.standard.set(getRemark, forKey: "GetRemarks")
        
        
        self.dismiss(animated: true){
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
            
        }
    
    
    }
    

}
