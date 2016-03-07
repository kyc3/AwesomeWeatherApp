//
//  City.swift
//  Awesome Weather App
//
//  Created by Winter, Yannick on 04.03.16.
//  Copyright © 2016 Winter, Yannick. All rights reserved.
//

import Foundation
import SQLite


class City: NSObject {
    
    var name: String = ""
    var temperature: String = ""
    var humidity: String = ""
    var pressure: String = ""
    var windSpeed: String = ""
    var weather: String = ""
    var weatherDescription: String = ""
    var cloudiness: String = ""
    var date: NSDate = NSDate()
    
    
    func toString() -> String {
        return "Name: \(self.name)\n Temperature: \(self.temperature)\n Humidity: \(self.humidity)\n pressure: \(self.pressure)\n windspeed: \(self.windSpeed)\n weather: \(self.weather)\n weatherDescription: \(self.weatherDescription)\n cloudiness: \(self.cloudiness)\n date: \(date)"
    }
}
