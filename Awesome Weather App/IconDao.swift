//
//  IconDao.swift
//  Awesome Weather App
//
//  Created by Winter, Yannick on 09.03.16.
//  Copyright © 2016 Winter, Yannick. All rights reserved.
//

import Foundation

class IconDao: NSObject {
    
    func insertIcon(icon: Icon) {
        DB.sharedInstance.insertIcon(icon)
    }
    
    func getIcon(iconTitle: String) -> Icon? {
        return DB.sharedInstance.getIcon(iconTitle)
    }

}