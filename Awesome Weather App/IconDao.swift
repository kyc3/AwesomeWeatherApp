//
//  IconDao.swift
//  Awesome Weather App
//
//  Created by Winter, Yannick on 09.03.16.
//  Copyright © 2016 Winter, Yannick. All rights reserved.
//

import Foundation
import SQLite

class IconDao: NSObject {
    static let iconTitle: String = "iconTitle"
    static let icon: String = "icon"
    func insertIcon(icon: Icon) {
        do {
            let chkData: NSData = self.getIcon(icon.iconTitle)!.icon
            if chkData.length == 0 { //check if icon is already in DB
                let db = try Connection(DB.sharedInstance.dbPath)
                let stmt = try db.prepare("INSERT INTO icons (\(IconDao.iconTitle),\(IconDao.icon)) VALUES (?,?)")
                let iconStr: String = icon.icon.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                //print(iconStr)
                do {
                    try stmt.run(icon.iconTitle,iconStr)
                }
                catch {
                    print("SQL Statement Error: \(error)")
                }
            }
            else {
                // icon is already in DB
            }
        }
        catch {
            print("Error inserting icon object")
        }
    }
    
    func getIcon(iconTitle: String) -> Icon? {
        do {
            let db = try Connection(DB.sharedInstance.dbPath)
            var imageData: NSData? = NSData()
            do {
                for row in try db.prepare("SELECT \(IconDao.icon) FROM icons WHERE \(IconDao.iconTitle)='\(iconTitle)'") {
                    
                    imageData = NSData(base64EncodedString: String(row[0]!), options: NSDataBase64DecodingOptions(rawValue: 0))
                }
                let icon: Icon = Icon()
                icon.iconTitle = iconTitle
                icon.icon = imageData!
                return icon
            }
            catch {
                print("error retrieving: \(error)")
            }
            return nil
        }
        catch {
            print("image could not be retrieved")
            return nil
        }
    }
    
}