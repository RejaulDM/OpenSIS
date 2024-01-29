//
//  ForgotPasswordViewController.swift
//  NHAI
//
//  Created by Abu Sahid Reza on 06/02/22.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    

    @IBOutlet weak var userIDTextField: UITextField!
    //var changePasswordValue = ChangePasswordViewController()
    var forgotPaswwordManager = ForgotPasswordManager()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        userIDTextField.leftView = paddingView
        userIDTextField.leftViewMode = .always
        userIDTextField.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        userIDTextField.layer.borderWidth = 1
        userIDTextField.layer.cornerRadius = userIDTextField.frame.size.height / 10
        forgotPaswwordManager.delegate = self

        
    }
    

    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if (sender.currentTitle == "SUBMIT"){
            
          textFieldValidation()
            
        }
        
        
        else if (sender.currentTitle == "CANCEL"){
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
}

extension ForgotPasswordViewController {
    
    func textFieldValidation(){
        
        if (userIDTextField.text?.isEmpty)!{
            
           self.displayAlertMessage(messageToDisplay: "Please fill up all the details")
        }
        
        else {
            
            forgotPaswwordManager.forgotpasswordApiHit(userID: userIDTextField.text!)
        }
        
        
    }
    
}

extension ForgotPasswordViewController: ForgotPasswordDelegate{
    func forgotPasswordData(forgetData: ForgotPasswordData) {
        
        if forgetData.responseStatus == true {
            
            self.displayAlertMessage(messageToDisplay: forgetData.responseText!)
            
        }
        
        else {
            
            self.displayAlertMessage(messageToDisplay: forgetData.responseText!)
        }
        
        
    }
    
    
    
    
    
}
