//
//  CalendarEventCell.swift
//  OpenSIS
//
//  Created by Rejaul on 2/1/23.
//

import UIKit

class CalendarEventCell: UITableViewCell {

    @IBOutlet weak var lblEventName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblEventName.layer.cornerRadius = 5
        lblEventName.layer.borderWidth = 1
        lblEventName.layer.borderColor  = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
