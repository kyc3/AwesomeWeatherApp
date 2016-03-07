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
    
    func insertCities(cities: [City]) {
        //empty the db
        do {
        let db = try Connection(self.dbPath)
            try db.execute("DELETE FROM cities")
            //insert new entries
            for city in cities {
                self.insert(city)
            }
        }
        catch {
            print("Error insertCities")
        }
        
    }
    
    
    func insert(city: City) {
        do {
        let db = try Connection(self.dbPath)
        let stmt = try db.prepare("INSERT INTO cities (name,temperature,humidity,pressure,windspeed,weather,weatherDescription,cloudiness,date) VALUES (?,?,?,?,?,?,?,?,?)")
        try stmt.run(city.name,city.temperature,city.humidity,city.pressure,city.windSpeed,city.weather,city.weatherDescription,city.cloudiness,String(city.date.timeIntervalSince1970))
        }
        catch _ {
            print("Error inserting city object")
        }
    }
    func getCites() ->[City]? {
        do {
        let db = try Connection(self.dbPath)
            var cities: [City] = [City]()
        for row in try db.prepare("SELECT id, name,temperature,humidity,pressure,cloudiness,weather,weatherDescription,windspeed,date FROM cities") {
            let city: City = City()
            city.name = String(row[1]!)
            city.temperature = String(row[2]!)
            city.humidity = String(row[3]!)
            city.pressure = String(row[4]!)
            city.cloudiness = String(row[5]!)
            city.weather = String(row[6]!)
            city.weatherDescription = String(row[7]!)
            city.windSpeed = String(row[8]!)
            let dt = String(row[9]!)
            city.date = NSDate(timeIntervalSince1970: Double(dt)!)
            cities.append(city)
        }
            return cities
        }
        catch {
            print("cities could not be retrieved")
            return nil
        }
    }
    
}