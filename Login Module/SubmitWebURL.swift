//
//  SubmitWebURL.swift
//  OpenSIS
//
//  Created by Rejaul on 11/20/22.
//

import UIKit
import DTTextField
import TransitionButton

class SubmitWebURL: UIViewController {

    
    @IBOutlet weak var textURL: DTTextField!
    
    @IBOutlet weak var submitButton: TransitionButton!
    
    @IBOutlet weak var viewURL: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textURL.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        let Key_BaseURL  = UserDefaults.standard.string(forKey: "Key_WebURL") ?? ""
        
        if Key_BaseURL == ""{
            textURL.text = "https://fedsis.doe.fm/"
        }else{
            textURL.text = Key_BaseURL
           /* textURL.attributedPlaceholder = NSAttributedString(string: "PACIFIC EMIS web address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]) */
        }
       
        self.textURL.layer.borderWidth = 2
        self.textURL.layer.cornerRadius = 8
        self.textURL.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        
        // Create a padding view for padding on left
        textURL.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textURL.frame.height))
        textURL.leftViewMode = .always
        
        //uiUpdate()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnTappedSubmit(_ sender: Any) {
        
        if (textURL.text?.isEmpty)!{
            self.displayAlertMessage(messageToDisplay: "Please Enter Web Address")
            
        }else{
                
                let passtext = textURL.text!
                let start = passtext.components(separatedBy: ":")
                let getUrl : String = start[1]
                print("getUrl====",getUrl)
                UserDefaults.standard.set(getUrl, forKey: "Key_SubURL")
                
                let tname = getUrl.components(separatedBy: "//")
                let tantName : String = tname[1]
                let gtname = tantName.components(separatedBy: ".")
                let gtantName : String = gtname[0]
                print("getUrl====",gtantName)
                UserDefaults.standard.set(gtantName, forKey: "Key_TentName")
                
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let contollerName = storyboard.instantiateViewController(withIdentifier: "Login1")
                self.present(contollerName, animated: true, completion: nil)
            }
    }
    

}


// UI Design

extension SubmitWebURL{
    
  private func uiUpdate(){
        
      
      textURL.borderStyle = .none
      
      textURL.attributedPlaceholder = NSAttributedString(string: "PACIFIC EMIS web address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
      
     
      self.submitButton.layer.cornerRadius = 8
      
      self.viewURL.layer.borderWidth = 2
      self.viewURL.layer.cornerRadius = 8
      self.viewURL.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      
      
        
    }
    
    
    
}
