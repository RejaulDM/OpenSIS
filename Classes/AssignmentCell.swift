//
//  AssignmentCell.swift
//  OpenSIS
//
//  Created by Rejaul on 2/10/23.
//

import UIKit
protocol BtnRightOption {
    func ClickCellID (index: Int)
}

protocol BtnRedirect {
    func ClickCellIDR (index: Int)
}

class AssignmentCell: UITableViewCell {
    
    @IBOutlet weak var btnSideMenu: UIButton!
    
    @IBOutlet weak var lblAssignmentName: UILabel!
    
    var ClickCellDelegateView: BtnRightOption?
    var indexID: IndexPath?
    
    var ClickCellDelegateViewR: BtnRedirect?
    var indexIDR: IndexPath?
    
    
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
    
    
    @IBAction func btnRedirect(_ sender: Any) {
        ClickCellDelegateViewR?.ClickCellIDR(index: (indexIDR?.row)!)
}
    
}
