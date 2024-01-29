//
//  NotificationMissingAttendanceCell.swift
//  OpenSIS
//
//  Created by Rejaul on 7/25/23.
//

import UIKit

protocol TakeAttendance {
    func ClickCellID (index: Int)
}

class NotificationMissingAttendanceCell: UITableViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblNotoficationName: UILabel!
    @IBOutlet weak var btnTitleTagAttendance: UIButton!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblRoom: UILabel!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblRoomGrade: UILabel!
    
    var ClickCellDelegate: TakeAttendance?
    var indexID: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnTitleTagAttendance.layer.cornerRadius = 8
        
        viewBack.layer.cornerRadius = 4
        viewBack.layer.borderWidth = 1
        viewBack.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
    }

    @IBAction func btnTapMarkAttendance(_ sender: Any) {
        ClickCellDelegate?.ClickCellID(index: (indexID?.row)!)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
