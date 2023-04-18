//
//  AttendanceMarkPopupCell.swift
//  OpenSIS
//
//  Created by Rejaul on 1/24/23.
//

import UIKit

class AttendanceMarkPopupCell: UITableViewCell {
    
    @IBOutlet weak var lblAttStatus: UILabel!
    
    @IBOutlet weak var viewBack: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
