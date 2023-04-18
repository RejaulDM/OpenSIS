//
//  GradeDetailsCell.swift
//  OpenSIS
//
//  Created by Rejaul on 1/31/23.
//

import UIKit

class GradeDetailsCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblID: UILabel!
    
    @IBOutlet weak var lblTotalNo: UILabel!
    
    @IBOutlet weak var textNumber: UITextView!
    
    @IBOutlet weak var textRemarks: UITextField!
    
    @IBOutlet weak var viewTotalAssig: UIView!
    
    @IBOutlet weak var viewBack: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBack.layer.cornerRadius = 8
        viewBack.layer.borderWidth = 1
        viewBack.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        viewTotalAssig.layer.cornerRadius = 3
        viewTotalAssig.layer.borderWidth = 1
        viewTotalAssig.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
