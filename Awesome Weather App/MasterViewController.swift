//
//  MasterViewController.swift
//  Awesome Weather App
//
//  Created by Winter, Yannick on 03.03.16.
//  Copyright © 2016 Winter, Yannick. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import MapKit

class MasterViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate, UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet weak var radiusButton: UIBarButtonItem!
    @IBOutlet weak var overViewTable: UITableView!
    
    let radiusOptions: [Int] = [1,2,3,4,5,6,7,8]
    
    var locationManager:CLLocationManager!
    var refreshControl: UIRefreshControl!
    var cities: [City] = [City]()
    var radius:Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.overViewTable.addSubview(self.refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func getWeatherDataLocation(lat: Double, long: Double, completionHandler: (responseData: NSDictionary?, error: NSError?) -> Void) {
        let url: String = "http://api.openweathermap.org/data/2.5/find?lat=\(lat)&lon=\(long)&cnt=\(self.radius)&units=metric&appid=92e560e91d10ec1da8179b74a9a01c0d"
        Alamofire.request(.GET, url).responseJSON() {
            response in switch response.result {
            case .Success(let JSON):
                let response = JSON as! NSDictionary
                completionHandler(responseData: response, error: nil)
            case .Failure(let error):
                completionHandler(responseData: nil, error: error)
            }
        }
    }
    
    func parseCityObjects(citiesRaw: [NSDictionary]) {
        for location in citiesRaw {
            var city: City = City()
            let mainObject = location.valueForKey("main") as! NSDictionary
            self.parseCityMainObject(mainObject, city: &city)
            let windObject = location.valueForKey("wind") as! NSDictionary
            self.parseCityWindObject(windObject, city: &city)
            let cloudObject = location.valueForKey("clouds") as! NSDictionary
            self.parseCityCloudObject(cloudObject, city: &city)
            let weatherObject = location.valueForKey("weather")?.objectAtIndex(0) as! NSDictionary
            self.parseCityWeatherObject(weatherObject, city: &city)
            city.name =  (location.valueForKey("name") as? String)!
            city.date = NSDate(timeIntervalSince1970: Double(location.valueForKey("dt")! as! NSNumber))
            self.cities.append(city)
        }
        self.insertCitiesIntoDB()
    }
    
    func insertCitiesIntoDB() {
        let db: CityDao = CityDao.sharedInstance
        do {
            try db.insertCities(self.cities) //insert all cities into DB
            if let db_Cities =  try db.getCites() {
                self.cities = db_Cities
            }
        }
        catch {
            print("Couldn't insert: \(error)")
        }
    }
    
    func parseCityMainObject(mainRaw: NSDictionary, inout city: City) {
        city.temperature = String(Double(mainRaw.valueForKey("temp")! as! NSNumber))
        city.humidity = String(mainRaw.valueForKey("humidity")!)
        city.pressure = String(mainRaw.valueForKey("pressure")!)
    }
    func parseCityWindObject(windRaw: NSDictionary, inout city: City) {
        city.windSpeed = String(windRaw.valueForKey("speed")!)
    }
    
    func parseCityCloudObject(cloudRaw: NSDictionary, inout city: City) {
        city.cloudiness = String(cloudRaw.valueForKey("all")!)
    }
    
    func parseCityWeatherObject(weatherRaw: NSDictionary, inout city: City) {
        city.weather = String(weatherRaw.valueForKey("main")!)
        city.weatherDescription = String(weatherRaw.valueForKey("description")!)
        city.icon = String(weatherRaw.valueForKey("icon")!)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        self.fetchData(manager.location!.coordinate.latitude, long: manager.location!.coordinate.longitude)
    }
    
    func fetchData(lat: Double, long: Double) {
        self.getWeatherDataLocation(lat, long: long) { response, error in
            if let data = response, locations = data.valueForKey("list") as? [NSDictionary] {
                self.handleSuccessfulFetch(locations)
            } else if let responseError = error {
                self.handleFetchWithError(responseError)
            }
            self.overViewTable.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func handleSuccessfulFetch(locations: [NSDictionary]) {
        print("succesfully got new data")
        self.cities.removeAll()
        self.parseCityObjects(locations)
    }
    
    func handleFetchWithError(error: NSError) {
        print("No cities found: \(error)")
        //get old data
        print("get old data instead")
        do {
            let db: CityDao = CityDao.sharedInstance
            if let db_Cities = try db.getCites() {
                self.cities = db_Cities
                
            }
        }
        catch {
            print("Error getting cities: \(error)")
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! WeatherOverviewCell
        let currentLocation = self.cities[indexPath.row]
        cell.cityNameLab?.text =  currentLocation.name
        cell.temperatureLabel?.text = currentLocation.temperature + " °C"
        cell.humidityLabel?.text = currentLocation.humidity + "%"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        cell.dateLabel?.text = dateFormatter.stringFromDate(currentLocation.date)
        self.getIcon(currentLocation.icon, completionHandler: {
            (theIcon: Icon) in
            cell.cellIconView.image = UIImage(data: theIcon.icon)
        })
        return cell
    }
    
    func getIcon(iconTitle: String, completionHandler: (theIcon: Icon) -> Void){
        let db: IconDao = IconDao()
        let icon: Icon = db.getIcon(iconTitle)!
        let imageData: NSData? = icon.icon
        if imageData?.length == 0 {
            //image not yet in DB
            icon.iconTitle = iconTitle
            self.fetchIcon(iconTitle, icon: icon, completionHandler: {
                (fetchedIcon: Icon) in
                completionHandler(theIcon: fetchedIcon)
            
            })
        }
        else {
            completionHandler(theIcon: icon)
        }
    }
    
    func fetchIcon(iconTitle: String, icon: Icon, completionHandler: (fetchedIcon: Icon)->Void) {
        let url: String = "http://openweathermap.org/img/w/\(iconTitle).png"
        Alamofire.request(.GET, url).response {
            (_,response,data,_) in
            if response?.statusCode == 200 {
                self.handleSuccessfulIconFetch(icon, data: data, completionHandler: {
                    (fetchedIcon) in
                    completionHandler(fetchedIcon: fetchedIcon)
                })
                self.overViewTable.reloadData()
            }
        }
    }
    
    func handleSuccessfulIconFetch(icon: Icon, data: NSData?, completionHandler: (icon: Icon)->Void) {
        icon.icon = data!
        let db = IconDao()
        db.insertIcon(icon)
        completionHandler(icon: icon)
    }
    
    func refresh(sender:AnyObject) {
        self.locationManager.startUpdatingLocation()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let cell = sender as? WeatherOverviewCell
            let indexPath = self.overViewTable.indexPathForCell(cell!)
            let cityObject = self.cities[indexPath!.row]
            let detailVC = segue.destinationViewController as! DetailViewController
            detailVC.cityObject = cityObject
            detailVC.image = cell!.cellIconView.image!
        }
    }
    
    @IBAction func chooseRadius(sender: AnyObject) {
        let pickerFrame = CGRectMake(0, (self.view.frame.height/3) * 2, self.view.frame.width, (self.view.frame.height/3))
        let picker = UIPickerView(frame: pickerFrame)
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.grayColor()
        self.view.addSubview(picker)
        picker.selectRow(self.radiusOptions.indexOf(self.radius)!, inComponent: 0, animated: false)
        self.radiusButton.enabled = false
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.radiusOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.radiusOptions[row])"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.radius = self.radiusOptions[row]
        self.locationManager.startUpdatingLocation()
        self.radiusButton.title = "Radius (\(self.radius))"
        pickerView.removeFromSuperview()
        self.radiusButton.enabled = true
    }
}
