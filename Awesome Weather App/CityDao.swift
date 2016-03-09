//
//  CityDao.swift
//  Awesome Weather App
//
//  Created by Winter, Yannick on 09.03.16.
//  Copyright © 2016 Winter, Yannick. All rights reserved.
//

import Foundation
//import SQLite

class CityDao: NSObject {
    
    func insertCities(cities: [City]) {
        DB.sharedInstance.insertCities(cities)
    }
    
    func getCites() ->[City]? {
        return DB.sharedInstance.getCites()
    }
    
}
