//
//  DB.swift
//  Awesome Weather App
//
//  Created by Winter, Yannick on 07.03.16.
//  Copyright © 2016 Winter, Yannick. All rights reserved.
//

import Foundation
import SQLite

class DB: NSObject {
    static let sharedInstance = DB()
    var dbPath: String
    override init() {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        self.dbPath = documentsURL.URLByAppendingPathComponent("cities.sqlite").path!
        super.init()
        self.copyFile("cities.sqlite")
    }
    
    func copyFile(fileName: NSString) {
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(dbPath) {
            let documentsURL = NSBundle.mainBundle().resourceURL
            let fromPath = documentsURL!.URLByAppendingPathComponent(fileName as String)
            var error : NSError?
            do {
                try fileManager.copyItemAtPath(fromPath.path!, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            //let alert: UIAlertView = UIAlertView()
            if (error != nil) {
                print("Error: \(error?.localizedDescription)")
            } else {
                print("Successfully copied")
            }
        }
    }
}