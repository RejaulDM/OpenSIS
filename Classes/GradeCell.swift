//
//  GradeCell.swift
//  OpenSIS
//
//  Created by Rejaul on 1/30/23.
//

import UIKit

class GradeCell: UITableViewCell {

    
    @IBOutlet weak var lblAssignmentName: UILabel!
    
    @IBOutlet weak var lblLanguageType: UILabel!
    
    @IBOutlet weak var assignDate: UILabel!
    
    @IBOutlet weak var lblDueDate: UILabel!
    
    @IBOutlet weak var viewBack: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBack.layer.cornerRadius = 8
        viewBack.layer.borderWidth = 1
        viewBack.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
