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
    static let sharedInstance = CityDao()
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
    private lazy var columnsWithId: Array<String> = {
        [unowned self] in
        return [self.id, self.name, self.temperature, self.humidity, self.pressure, self.windspeed, self.weather, self.weatherDescription, self.cloudiness, self.date, self.icon]
    }()
    private lazy var columnsWithoutId: Array<String> = {
        [unowned self] in
        return [self.name, self.temperature, self.humidity, self.pressure, self.windspeed, self.weather, self.weatherDescription, self.cloudiness, self.date, self.icon]
    }()
    
    func insertCities(cities: [City]) throws {
        //empty the db
        guard let db = super.connection else {
            throw EURODB.DBError.NO_CONNECTION("No Connection to DB")
        }
        try db.execute(EURODB.deleteAll(self.tableName))
        //insert new entries
        for city in cities {
            try self.insert(city)
        }
    }
    
    func insert(city: City) throws {
        guard let db = super.connection else {
            throw EURODB.DBError.NO_CONNECTION("No Connection to DB")
        }
        let stmt = try db.prepare(EURODB.insert(self.tableName, columns: self.columnsWithoutId))
        try stmt.run(city.name, city.temperature, city.humidity, city.pressure, city.windSpeed, city.weather, city.weatherDescription, city.cloudiness, String(city.date.timeIntervalSince1970), city.icon)
    }

    func getCites() throws ->[City]? {
        guard let db = super.connection else {
            throw EURODB.DBError.NO_CONNECTION("No Connection to DB")
        }
        var cities: [City] = [City]()
        for row in try db.prepare(EURODB.selectWithoutCondition(self.tableName, columns: self.columnsWithId)) {
            let city: City = City()
            city.id = String(row[0]!)
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

    func updateCity(city: City) throws {
        guard let db = super.connection else {
            throw EURODB.DBError.NO_CONNECTION("No Connection to DB")
        }
        let stmt = try db.prepare(EURODB.updateWithCondition(self.tableName, updateColumns: self.columnsWithoutId, conditionColumns: [self.id], conditionValues: [city.id]))
        try stmt.run(city.name, city.temperature, city.humidity, city.pressure, city.windSpeed, city.weather, city.weatherDescription, city.cloudiness, String(city.date.timeIntervalSince1970), city.icon)
    }
}
