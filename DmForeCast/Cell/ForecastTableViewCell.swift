//
//  ForecastTableViewCell.swift
//  DmForeCast
//
//  Created by Walter yun on 2021/05/28.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    //타입 프로퍼티
    static let identifier = "ForecastTableViewCell"
    
    
    @IBOutlet weak var dataLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        statusLabel.textColor = .white
        dataLabel.textColor = statusLabel.textColor
        timeLabel.textColor = statusLabel.textColor
        temperatureLabel.textColor = statusLabel.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
