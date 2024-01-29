//
//  MissingAttendanceListCell.swift
//  OpenSIS
//
//  Created by Rejaul on 7/26/23.
//

import UIKit
protocol BtnAttStatusMiss {
    func ClickCellAttMiss (index: Int)
}

protocol BtnMSGMiss {
    func ClickCellMSGMiss (index: Int)
}

class MissingAttendanceListCell: UITableViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblID: UILabel!
    
    @IBOutlet weak var lblAltID: UILabel!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    @IBOutlet weak var btnTitlePresentSatus: UIButton!
    
    var ClickCellDelegateAtt: BtnAttStatusMiss?
    var indexIDAtt: IndexPath?
    
    var ClickCellDelegateMSG: BtnMSGMiss?
    var indexIDMSG: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBack.layer.cornerRadius = 8
        viewBack.layer.borderWidth = 1
        viewBack.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
         imgProfile.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btnTapAttStatus(_ sender: Any) {
        
        ClickCellDelegateAtt?.ClickCellAttMiss(index: (indexIDAtt?.row)!)
    }
    
    @IBAction func btnTapMsg(_ sender: Any) {
        
        ClickCellDelegateMSG?.ClickCellMSGMiss(index: (indexIDMSG?.row)!)
    }
    
}
