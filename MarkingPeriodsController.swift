//
//  MarkingPeriodsController.swift
//  OpenSIS
//
//  Created by Rejaul on 2/3/23.
//

import UIKit

class MarkingPeriodsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnTappedHome(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardNav")
        self.present(controller, animated: true, completion: nil)
    }
    

    @IBAction func btnTappedClass(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Classes", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ClassesController")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnTappedSchedul(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Schedule", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ScheduleController")
        self.present(controller, animated: true, completion: nil)
    }
    
}
