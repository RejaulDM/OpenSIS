//
//  SchoolsDetailsWashInfo.swift
//  OpenSIS
//
//  Created by Rejaul on 1/7/23.
//

import UIKit

class SchoolsDetailsWashInfo: UIViewController {
    
    @IBOutlet weak var lblSchoolsName: UILabel!
    
    @IBOutlet weak var lblRunningWater: UILabel!
    @IBOutlet weak var lblMainSourceDrinkingWater: UILabel!
    @IBOutlet weak var lblCurrentlyAvailable: UILabel!
    @IBOutlet weak var lblHandwashingAvailable: UILabel!
    @IBOutlet weak var lblSoapWaterAvailable: UILabel!
    @IBOutlet weak var lblHygeneEducation: UILabel!
    @IBOutlet weak var lblFemaleToiletType: UILabel!
    @IBOutlet weak var lblTotalFemaleToilets: UILabel!
    @IBOutlet weak var lblTotalFemaleToiletsUsable: UILabel!
    @IBOutlet weak var lblFemaleToiletAccessibility: UILabel!
    @IBOutlet weak var lblMaleToiletType: UILabel!
    @IBOutlet weak var lblTotalMaleToilets: UILabel!
    @IBOutlet weak var lblTotalMaleToiletsUsable: UILabel!
    @IBOutlet weak var lblMaleToiletAccessibility: UILabel!
    @IBOutlet weak var lblCommonToiletType: UILabel!
    @IBOutlet weak var lblTotalCommonToilets: UILabel!
    @IBOutlet weak var lblTotalCommonToiletsUsable: UILabel!
    @IBOutlet weak var lblCommonToiletAccessibility: UILabel!
    
    var  Key_runningWater = UserDefaults.standard.string(forKey: "Key_runningWater") ?? ""
    var  Key_SourceOfDrinkingWater = UserDefaults.standard.string(forKey: "Key_SourceOfDrinkingWater") ?? ""
    var  Key_currentlyAvailable = UserDefaults.standard.string(forKey: "Key_currentlyAvailable") ?? ""
    var  Key_handwashingAvailable = UserDefaults.standard.string(forKey: "Key_handwashingAvailable") ?? ""
    var  Key_soapAndWaterAvailable = UserDefaults.standard.string(forKey: "Key_soapAndWaterAvailable") ?? ""
    var  Key_hygeneEducation = UserDefaults.standard.string(forKey: "Key_hygeneEducation") ?? ""
    
    var  Key_femaleToiletType = UserDefaults.standard.string(forKey: "Key_femaleToiletType") ?? ""
    var  Key_totalFemaleToilets = UserDefaults.standard.string(forKey: "Key_totalFemaleToilets") ?? ""
    var  Key_totalFemaleToiletsUsable = UserDefaults.standard.string(forKey: "Key_totalFemaleToiletsUsable") ?? ""
    var  Key_femaleToiletAccessibility = UserDefaults.standard.string(forKey: "Key_femaleToiletAccessibility") ?? ""
    
    
    var  Key_maleToiletType = UserDefaults.standard.string(forKey: "Key_maleToiletType") ?? ""
    var  Key_totalMaleToilets = UserDefaults.standard.string(forKey: "Key_totalMaleToilets") ?? ""
    var  Key_totalMaleToiletsUsable = UserDefaults.standard.string(forKey: "Key_totalMaleToiletsUsable") ?? ""
    var  Key_maleToiletAccessibility = UserDefaults.standard.string(forKey: "Key_maleToiletAccessibility") ?? ""
    
    
    var  Key_comonToiletType = UserDefaults.standard.string(forKey: "Key_comonToiletType") ?? ""
    var  Key_totalCommonToilets = UserDefaults.standard.string(forKey: "Key_totalCommonToilets") ?? ""
    var  Key_totalCommonToiletsUsable = UserDefaults.standard.string(forKey: "Key_totalCommonToiletsUsable") ?? ""
    var  Key_commonToiletAccessibility = UserDefaults.standard.string(forKey: "Key_commonToiletAccessibility") ?? ""
    
    var  storeSchoolName = UserDefaults.standard.string(forKey: "Key_SchoolName") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblSchoolsName.text = storeSchoolName

        if Key_runningWater == "true"{
            self.lblRunningWater.text = "Yes"
        }else{
            self.lblRunningWater.text = ""
        }
        
        if Key_currentlyAvailable == "true"{
            self.lblCurrentlyAvailable.text = "Yes"
        }else{
            self.lblCurrentlyAvailable.text = ""
        }
        
        if Key_handwashingAvailable == "true"{
            self.lblHandwashingAvailable.text = "Yes"
        }else{
            self.lblHandwashingAvailable.text = ""
        }
        
        if Key_soapAndWaterAvailable == "true"{
            self.lblSoapWaterAvailable.text = "Yes"
        }else{
            self.lblSoapWaterAvailable.text = ""
        }
        
        if Key_hygeneEducation == "true"{
            self.lblHygeneEducation.text = "Yes"
        }else{
            self.lblHygeneEducation.text = ""
        }
        
        self.lblMainSourceDrinkingWater.text = Key_SourceOfDrinkingWater
        
        
        self.lblFemaleToiletType.text = Key_femaleToiletType
        self.lblTotalFemaleToilets.text = Key_totalFemaleToilets
        self.lblTotalFemaleToiletsUsable.text = Key_totalFemaleToiletsUsable
        self.lblFemaleToiletAccessibility.text = Key_femaleToiletAccessibility

        
        self.lblMaleToiletType.text =  Key_maleToiletType
        self.lblTotalMaleToilets.text = Key_totalMaleToilets
        self.lblTotalMaleToiletsUsable.text = Key_totalMaleToiletsUsable
        self.lblMaleToiletAccessibility.text = Key_maleToiletAccessibility
        
        
        self.lblCommonToiletType.text = Key_comonToiletType
        self.lblTotalCommonToilets.text = Key_totalCommonToilets
        self.lblTotalCommonToiletsUsable.text = Key_totalCommonToiletsUsable
        self.lblCommonToiletAccessibility.text = Key_commonToiletAccessibility
        
       
        
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnTappedGen(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Schools", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SchoolsDetailsInfo")
        self.present(controller, animated: true, completion: nil)
    }
    

    @IBAction func btnBack(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Schools", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SchoolsController")
        self.present(controller, animated: true, completion: nil)
    }
    
}
