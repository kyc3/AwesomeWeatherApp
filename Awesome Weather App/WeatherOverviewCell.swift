//
//  WeatherOverviewCell.swift
//  Awesome Weather App
//
//  Created by Winter, Yannick on 04.03.16.
//  Copyright © 2016 Winter, Yannick. All rights reserved.
//

import UIKit

class WeatherOverviewCell: UITableViewCell {
    
    
    @IBOutlet weak var cityNameLab: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
