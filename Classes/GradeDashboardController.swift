//
//  GradeDashboardController.swift
//  OpenSIS
//
//  Created by Rejaul on 5/15/23.
//

import UIKit

class GradeDashboardController: UIViewController {
    
    @IBOutlet weak var btnActionInputGrade: UIButton!
    
    @IBOutlet weak var btnActionGradeBook: UIButton!
    
    
    
    var container: GradeContainer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnActionGradeBook.layer.cornerRadius = 8
        btnActionInputGrade.layer.cornerRadius = 8
        
        btnActionGradeBook.setTitleColor(.white, for: .normal)
        btnActionGradeBook.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        container!.segueIdentifierReceivedFromParent("SegueGradeBookCon")

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnTappedGradeBook(_ sender: Any) {
        btnActionGradeBook.setTitleColor(.white, for: .normal)
        btnActionGradeBook.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        btnActionInputGrade.setTitleColor(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1), for: .normal)
        btnActionInputGrade.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        container!.segueIdentifierReceivedFromParent("SegueGradeBookCon")
        
    }
    
    
    @IBAction func btnTappedInputGrade(_ sender: Any) {
        
        btnActionInputGrade.setTitleColor(.white, for: .normal)
        btnActionInputGrade.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        btnActionGradeBook.setTitleColor(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1), for: .normal)
        btnActionGradeBook.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        container!.segueIdentifierReceivedFromParent("SegueGradeInput")
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GradeSegua"{
            container = segue.destination as? GradeContainer
            
            container.animationDurationWithOptions = (0.5, .transitionCrossDissolve)
        }
    }
}
