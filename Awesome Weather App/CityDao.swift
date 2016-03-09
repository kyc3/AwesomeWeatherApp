//
//  CityDao.swift
//  Awesome Weather App
//
//  Created by Winter, Yannick on 09.03.16.
//  Copyright © 2016 Winter, Yannick. All rights reserved.
//

import Foundation
import SQLite

class CityDao: NSObject {
    static let id:String = "id"
    static let name: String = "name"
    static let temperature: String = "temperature"
    static let humidity: String = "humidity"
    static let pressure: String = "pressure"
    static let windspeed: String = "windspeed"
    static let weather: String = "weather"
    static let weatherDescription: String = "weatherDescription"
    static let cloudiness: String = "cloudiness"
    static let date: String = "date"
    static let icon: String = "icon"
    
    func insertCities(cities: [City]) {
        //empty the db
        let db = DB.sharedInstance.connection!
        do {
            try db.execute("DELETE FROM cities")
        }
        catch{
            print("error in delete")
        }
        //insert new entries
        for city in cities {
            self.insert(city)
        }
    }
    
    func insert(city: City) {
        do {
            let db = DB.sharedInstance.connection!
            let stmt = try db.prepare("INSERT INTO cities (\(CityDao.name),\(CityDao.temperature),\(CityDao.humidity),\(CityDao.pressure),\(CityDao.windspeed),\(CityDao.weather),\(CityDao.weatherDescription),\(CityDao.cloudiness),\(CityDao.date),\(CityDao.icon)) VALUES (?,?,?,?,?,?,?,?,?,?)")
            try stmt.run(city.name,city.temperature,city.humidity,city.pressure,city.windSpeed,city.weather,city.weatherDescription,city.cloudiness,String(city.date.timeIntervalSince1970),city.icon)
        }
        catch {
            print("Error inserting city object: \(error)")
        }
    }
    
    func getCites() ->[City]? {
        do {
            let db = DB.sharedInstance.connection!
            var cities: [City] = [City]()
            for row in try db.prepare("SELECT \(CityDao.id),\(CityDao.name),\(CityDao.temperature),\(CityDao.humidity),\(CityDao.pressure),\(CityDao.cloudiness),\(CityDao.weather),\(CityDao.weatherDescription),\(CityDao.windspeed),\(CityDao.date),\(CityDao.icon) FROM cities") {
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
                city.icon = String(row[10]!)
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
