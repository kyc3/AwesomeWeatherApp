//
//  CityDao.swift
//  Awesome Weather App
//
//  Created by Winter, Yannick on 09.03.16.
//  Copyright © 2016 Winter, Yannick. All rights reserved.
//

import Foundation
import SQLite

class CityDao: EURODB {
    private let tableName = "cities"
    private let id:String = "id"
    private let name: String = "name"
    private let temperature: String = "temperature"
    private let humidity: String = "humidity"
    private let pressure: String = "pressure"
    private let windspeed: String = "windspeed"
    private let weather: String = "weather"
    private let weatherDescription: String = "weatherDescription"
    private let cloudiness: String = "cloudiness"
    private let date: String = "date"
    private let icon: String = "icon"
    
    func insertCities(cities: [City]) {
        //empty the db
        let db = super.connection!
        do {
            try db.execute(EURODB.deleteAll(self.tableName))
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
        //let db = super.connection!
        let columns = [self.name,self.temperature,self.humidity,self.pressure,self.windspeed,self.weather,self.weatherDescription,self.cloudiness,self.date,self.icon]
        let stmt: Statement? = super.insert(self.tableName, columns: columns)
        if stmt != nil {
            do {
                try stmt!.run(city.name,city.temperature,city.humidity,city.pressure,city.windSpeed,city.weather,city.weatherDescription,city.cloudiness,String(city.date.timeIntervalSince1970),city.icon)
            }
            catch {
                print("Error inserting city object: \(error)")
            }
        }
        else {
            print("statement was nil")
        }
    }
    
    func getCites() ->[City]? {
        do {
            let db = super.connection!
            var cities: [City] = [City]()
            let columns = [self.id,self.name,self.temperature,self.humidity,self.pressure,self.windspeed,self.weather,self.weatherDescription,self.cloudiness,self.date,self.icon]
            for row in try db.prepare(EURODB.selectWithoutCondition(self.tableName, columns: columns)) {
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
