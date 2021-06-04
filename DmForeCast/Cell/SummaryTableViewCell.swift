//
//  SummaryTableViewCell.swift
//  DmForeCast
//
//  Created by Walter yun on 2021/05/27.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    //타입 프로퍼티
    static let identifier = "SummaryTableViewCell"
    
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var minMaxLabel: UILabel!
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //cell의 backgroundColor 설정 clear color
        backgroundColor = .clear
        //text컬러
        statusLabel.textColor = .white
        minMaxLabel.textColor = .white//statusLabel.textColor
        currentTemperatureLabel.textColor = .white//statusLabel.textColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
