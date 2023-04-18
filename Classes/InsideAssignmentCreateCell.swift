//
//  InsideAssignmentCreateCell.swift
//  OpenSIS
//
//  Created by Rejaul on 2/17/23.
//

import UIKit
protocol BtnRightOptionAss {
    func ClickCellID (index: Int)
}

class InsideAssignmentCreateCell: UITableViewCell {
    
    @IBOutlet weak var btnActionRightOption: UIButton!
    
    @IBOutlet weak var lblAssignMentName: UILabel!
    
    @IBOutlet weak var lblPoints: UILabel!
    
    @IBOutlet weak var lblAssignmentDate: UILabel!
    
    @IBOutlet weak var lblDueDate: UILabel!
    
    @IBOutlet weak var viewBack: UIView!
    
    var ClickCellDelegateView: BtnRightOptionAss?
    var indexID: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btnTappedOption(_ sender: Any) {
        ClickCellDelegateView?.ClickCellID(index: (indexID?.row)!)
        
    }
    
}
