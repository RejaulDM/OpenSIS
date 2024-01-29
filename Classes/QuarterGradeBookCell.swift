//
//  QuarterGradeBookCell.swift
//  OpenSIS
//
//  Created by Rejaul on 2/7/23.
//

import UIKit
import DTTextField
import SearchTextField

protocol BtnUserText1 {
    func ClickCellID1 (index: Int)
}
protocol BtnUserText2 {
    func ClickCellID2 (index: Int)
}


class QuarterGradeBookCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var lblQuaterName: UILabel!
    
    @IBOutlet weak var textQuater1: DTTextField!
    
    @IBOutlet weak var textQuater1Exam: DTTextField!
    
    var ClickCellDelegate1: BtnUserText1?
    var indexID1: IndexPath?
    
    var ClickCellDelegate2: BtnUserText2?
    var indexID2: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textQuater1.layer.borderWidth = 0.5
        textQuater1.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        textQuater1Exam.layer.borderWidth = 0.5
        textQuater1Exam.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        textQuater1.attributedPlaceholder = NSAttributedString(string: "Quater 1", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        textQuater1Exam.attributedPlaceholder = NSAttributedString(string: "Quater 1 Exam", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        //clickable label code
        let tapRe = UITapGestureRecognizer(target: self, action: #selector(QuarterGradeBookCell.tappRe))
        textQuater1.isUserInteractionEnabled = true
        textQuater1.addGestureRecognizer(tapRe)
        
        //clickable label code
        let tapRe1 = UITapGestureRecognizer(target: self, action: #selector(QuarterGradeBookCell.tappRe1))
        textQuater1Exam.isUserInteractionEnabled = true
        textQuater1Exam.addGestureRecognizer(tapRe1)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @objc func tappRe(sender: UITapGestureRecognizer) {
        print("tap working")
        
      ClickCellDelegate1?.ClickCellID1(index: (indexID1?.row)!)
        
    }
    
    @objc func tappRe1(sender: UITapGestureRecognizer) {
        print("tap working")
        
      ClickCellDelegate2?.ClickCellID2(index: (indexID2?.row)!)
        
    }

}
