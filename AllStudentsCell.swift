//
//  AllStudentsCell.swift
//  OpenSIS
//
//  Created by Rejaul on 1/7/23.
//

import UIKit

class AllStudentsCell: UITableViewCell {

    
    @IBOutlet weak var lblStudentName: UILabel!
    
    @IBOutlet weak var lblID: UILabel!
    
    @IBOutlet weak var viewBack: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBack.layer.cornerRadius = 10
        viewBack.layer.borderWidth = 1
        viewBack.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
