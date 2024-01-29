//
//  LatterGradeCell.swift
//  OpenSIS
//
//  Created by Rejaul on 5/16/23.
//

import UIKit
import iOSDropDown
class LatterGradeCell: UITableViewCell {

    @IBOutlet weak var lblPercent: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var selectGrade: DropDown!
    @IBOutlet weak var textComment: UITextField!
    
    
    @IBOutlet weak var viewBack: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectGrade.layer.borderWidth = 0.5
        selectGrade.layer.borderColor =  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        selectGrade.layer.cornerRadius = 4
        
        lblPercent.layer.borderWidth = 0.5
        lblPercent.layer.borderColor =  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        lblPercent.layer.cornerRadius = 4
        
        textComment.layer.borderWidth = 0.5
        textComment.layer.borderColor =  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        textComment.layer.cornerRadius = 4
        
        viewBack.layer.borderWidth = 0.5
        viewBack.layer.borderColor =  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        viewBack.layer.cornerRadius = 4
        
        // Select Relation
        let option =  Options()
        selectGrade.inputView = UIView()
        self.selectGrade.tintColor = .clear
        
        selectGrade.optionArray = option.arrGradeList
        selectGrade.optionIds = option.ids
        selectGrade.checkMarkEnabled = false
        selectGrade.didSelect{(selectedText , index , id) in
            //self.ModeID = option.selectModeID[index]
            //print(self.ModeID,"select ModeID==")
            
        }
        selectGrade.arrowSize = 17
        self.selectGrade.isSearchEnable = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
