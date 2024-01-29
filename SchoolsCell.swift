//
//  SchoolsCell.swift
//  OpenSIS
//
//  Created by Rejaul on 11/30/22.
//

import UIKit

class SchoolsCell: UITableViewCell {

    @IBOutlet weak var lblSchoolsName: UILabel!
    
    @IBOutlet weak var lblSchoolsDec: UILabel!
    
    @IBOutlet weak var imgSchool: UIImageView!
    
    @IBOutlet weak var viewBack: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBack.layer.cornerRadius = 10
        viewBack.layer.borderWidth = 1
        viewBack.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        imgSchool.layer.cornerRadius = 10
        imgSchool.layer.borderWidth = 0.5
        imgSchool.layer.borderColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        imgSchool.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
