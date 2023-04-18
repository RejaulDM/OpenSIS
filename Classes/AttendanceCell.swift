//
//  AttendanceCell.swift
//  OpenSIS
//
//  Created by Rejaul on 1/22/23.
//

import UIKit

protocol BtnAttStatus {
    func ClickCellAtt (index: Int)
}

protocol BtnMSG {
    func ClickCellMSG (index: Int)
}

class AttendanceCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblID: UILabel!
    
    @IBOutlet weak var lblAltID: UILabel!
    
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var btnTitlePresentSatus: UIButton!
    
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    var ClickCellDelegateAtt: BtnAttStatus?
    var indexIDAtt: IndexPath?
    
    var ClickCellDelegateMSG: BtnMSG?
    var indexIDMSG: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBack.layer.cornerRadius = 8
        viewBack.layer.borderWidth = 1
        viewBack.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
 
    
    @IBAction func btnTapedPresent(_ sender: Any) {
        
        ClickCellDelegateAtt?.ClickCellAtt(index: (indexIDAtt?.row)!)
    }
    
    
    
    @IBAction func btnTapMessage(_ sender: Any) {
        
        ClickCellDelegateMSG?.ClickCellMSG(index: (indexIDMSG?.row)!)
    }
    

}
