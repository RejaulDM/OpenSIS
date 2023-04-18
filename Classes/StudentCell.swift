//
//  StudentCell.swift
//  OpenSIS
//
//  Created by Rejaul on 1/20/23.
//

import UIKit

protocol EmpCall {
    func ClickCellInFView (index: Int)
}

protocol EmpMail {
    func ClickCellOutFView (index: Int)
}

class StudentCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblID: UILabel!
    
    @IBOutlet weak var lblAltID: UILabel!
    
    @IBOutlet weak var lblGrade: UILabel!
    
    @IBOutlet weak var lblRound: UILabel!
    
    @IBOutlet weak var lblRound1: UILabel!
    
    @IBOutlet weak var viewBack: UIView!
    
    var ClickCellDelegateEmpInFile: EmpCall?
    var indexIDEmpInFile: IndexPath?
    
    var ClickCellDelegateEmpOutFile: EmpMail?
    var indexIDEmpOutFile: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblRound.layer.cornerRadius = lblRound.frame.width/2
        lblRound.layer.masksToBounds = true
        
        lblRound1.layer.cornerRadius = lblRound1.frame.width/2
        lblRound1.layer.masksToBounds = true
        
        viewBack.layer.cornerRadius = 8
        viewBack.layer.borderWidth = 1
        viewBack.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnMail(_ sender: Any) {
        
        ClickCellDelegateEmpOutFile?.ClickCellOutFView(index: (indexIDEmpOutFile?.row)!)
    }
    
    
    @IBAction func btnCall(_ sender: Any) {
        ClickCellDelegateEmpInFile?.ClickCellInFView(index: (indexIDEmpInFile?.row)!)
        }
    
}
