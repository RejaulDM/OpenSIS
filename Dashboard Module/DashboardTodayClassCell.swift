//
//  DashboardTodayClassCell.swift
//  OpenSIS
//
//  Created by Rejaul on 11/25/22.
//

import UIKit

class DashboardTodayClassCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSubjectCode: UILabel!
    
    @IBOutlet weak var lblCourseSection: UILabel!
    
    @IBOutlet weak var lblDot: UILabel!
    @IBOutlet weak var lblGrade: UILabel!
    
    @IBOutlet weak var lblRoomCode: UILabel!
    
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var lblPeriod: UILabel!
    
    
    @IBOutlet weak var lblSun: UILabel!
    @IBOutlet weak var lblMon: UILabel!
    @IBOutlet weak var lblTue: UILabel!
    @IBOutlet weak var lblWed: UILabel!
    @IBOutlet weak var lblThus: UILabel!
    @IBOutlet weak var lblFri: UILabel!
    @IBOutlet weak var lblSat: UILabel!
    
    
    
}


extension UIView {

func addShadowView() {
    //Remove previous shadow views
    superview?.viewWithTag(119900)?.removeFromSuperview()

    //Create new shadow view with frame
    let shadowView = UIView(frame: frame)
    shadowView.tag = 119900
    shadowView.layer.shadowColor = UIColor.black.cgColor
    shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
    shadowView.layer.masksToBounds = false

    shadowView.layer.shadowOpacity = 0.3
    shadowView.layer.shadowRadius = 3
    shadowView.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    shadowView.layer.rasterizationScale = UIScreen.main.scale
    shadowView.layer.shouldRasterize = true

    superview?.insertSubview(shadowView, belowSubview: self)
}}
