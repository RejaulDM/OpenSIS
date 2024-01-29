//
//  ClassesCell.swift
//  OpenSIS
//
//  Created by Rejaul on 11/30/22.
//

import UIKit

class ClassesCell: UITableViewCell {

    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var lblRoomCode: UILabel!
    
    @IBOutlet weak var lblDot: UILabel!
    
    @IBOutlet weak var lblCourseType: UILabel!
    
    @IBOutlet weak var lblCourseName: UILabel!
    
    @IBOutlet weak var lblSun: UILabel!
    
    @IBOutlet weak var lblMon: UILabel!
    
    @IBOutlet weak var lblTue: UILabel!
    
    @IBOutlet weak var lblWed: UILabel!
    
    @IBOutlet weak var lblThus: UILabel!
    
    @IBOutlet weak var lblFri: UILabel!
    
    @IBOutlet weak var lblSatu: UILabel!
    
    @IBOutlet weak var lblGrade: UILabel!
    
    @IBOutlet weak var lblPeriod: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    
    @IBOutlet weak var lblVSheduleText: UILabel!
    
    @IBOutlet weak var viewDayList: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBack.layer.cornerRadius = 10
        viewBack.layer.borderWidth = 1
        viewBack.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        lblRoomCode.layer.cornerRadius = 6
        lblRoomCode.layer.borderWidth = 1
        lblRoomCode.layer.borderColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        lblRoomCode.layer.masksToBounds = true
        
        lblDot.layer.cornerRadius = lblDot.frame.width/2
        lblDot.layer.masksToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
