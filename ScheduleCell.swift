//
//  ScheduleCell.swift
//  OpenSIS
//
//  Created by Rejaul on 1/12/23.
//

import UIKit

class ScheduleCell: UITableViewCell {

    @IBOutlet weak var lblPeriod: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblSubject: UILabel!
    
    @IBOutlet weak var lblGrade: UILabel!
    
    @IBOutlet weak var viewBack: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBack.layer.cornerRadius = 0
        viewBack.layer.borderWidth = 1
        viewBack.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
