//
//  Global.swift
//  NHAI
//
//  Created by Genius Consultants Ltd on 29/12/21.
//

import UIKit

//Global Cuestom UI Textfield Design

extension UITextField{
        
        func customTextField(){
            
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
            self.leftView = paddingView
            self.leftViewMode = .always
            self.layer.borderColor = #colorLiteral(red: 0.1665209234, green: 0.4876173139, blue: 0.7231122851, alpha: 1)
            self.layer.borderWidth = 1
        }
        
    }


// Global Display Alert 

extension UIViewController {
      
    
    
       func displayAlertMessage(messageToDisplay: String) {
           
           let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
           
           let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
               
               // Code in this block will trigger when OK button tapped.
               print("Ok button tapped");
               
               
              /* let storyboard = UIStoryboard(name: "Login", bundle: nil)
               let contollerName = storyboard.instantiateViewController(withIdentifier: "Login1")
               self.present(contollerName, animated: true, completion: nil) */
           }
           
           alertController.addAction(OKAction)
           
           self.present(alertController, animated: true, completion:nil)
       }
}

// Encode and Decode

extension String {
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    //    "heroes".base64Encoded() // It will return: aGVyb2Vz
    //    "aGVyb2Vz".base64Decoded() // It will return: heroes
}



extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}


extension UIViewController {
    //*Loading Funtion Alert
    func displayIndicatorAlert( message: String) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
  
    
    func hideKeyboardWhenTappedAround()
    { let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)); view.addGestureRecognizer(tapGesture)
        
    }
    @objc func hideKeyboard()
    {
        view.endEditing(true)
        
        
    }
    
}

var selectAllAssignment = [SelectedAssignment]()
