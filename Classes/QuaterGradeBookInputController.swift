//
//  QuaterGradeBookInputController.swift
//  OpenSIS
//
//  Created by Rejaul on 2/9/23.
//

import UIKit

class QuaterGradeBookInputController: UIViewController {

    
    @IBOutlet weak var enetrText: UITextField!
    
    @IBOutlet weak var lblFieldName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enetrText.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        enetrText.layer.borderWidth = 1

        // Do any additional setup after loading the view.
    }

    @IBAction func btnCancel(_ sender: Any) {
        
        self.dismiss(animated: true){
           
        }
        
    }
    
    
    @IBAction func btnSubmit(_ sender: Any) {
        
        let getRemark = enetrText.text!
        
        UserDefaults.standard.set(getRemark, forKey: "GetQuaterText")
        
        
        self.dismiss(animated: true){
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
            
        }
    
    
    }
    
}
