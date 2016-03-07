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
    var locationManager:CLLocationManager!
    //var locationArray = []
    var refreshControl: UIRefreshControl!
    var cities: [City] = [City]()
    let radiusOptions: [Int] = [1,2,3,4,5,6,7,8]
    var radius:Int = 4

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.overViewTable.addSubview(self.refreshControl)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getWeatherDataToLocation(lat: Double, lon: Double) {
        var url: String
        url = "http://api.openweathermap.org/data/2.5/find?lat=\(lat)&lon=\(lon)&cnt=\(self.radius)&units=metric&appid=44db6a862fba0b067b1930da0d769e98"
        Alamofire.request(.GET, url).responseJSON() {
            response in switch response.result {
            case .Success(let JSON):
                
                let response = JSON as! NSDictionary
                
                if (response.valueForKey("list") != nil) {
                    print("succesfully got new data")
                    self.cities.removeAll()
                    let locationArray = response.valueForKey("list")! as! NSArray
                    
                    for location in locationArray {
                        
                        let mainObject = location.valueForKey("main") as! NSDictionary
                        let windObject = location.valueForKey("wind") as! NSDictionary
                        let cloudObject = location.valueForKey("clouds") as! NSDictionary
                        let weatherObject = location.valueForKey("weather")?.objectAtIndex(0) as! NSDictionary

                        let city: City = City()
                        city.name =  (location.valueForKey("name") as? String)!
                        city.temperature = String(mainObject.valueForKey("temp")!)
                        city.humidity = String(mainObject.valueForKey("humidity")!)
                        city.pressure = String(mainObject.valueForKey("pressure")!)
                        city.windSpeed = String(windObject.valueForKey("speed")!)
                        city.cloudiness = String(cloudObject.valueForKey("all")!)
                        city.weather = String(weatherObject.valueForKey("main")!)
                        city.weatherDescription = String(weatherObject.valueForKey("description")!)
                        city.date = NSDate(timeIntervalSince1970: Double(location.valueForKey("dt")! as! NSNumber))

                        self.cities.append(city)
                        
                        
                        
                    }
                    
                    let db: DB = DB()
                    db.insertCities(self.cities) //insert all cities into DB
                    
                    if let db_Cities = db.getCites() {
                        self.cities = db_Cities
                        
                    }
                    /* chk all entries
                    self.cities = db.getCites()!
                    for city in self.cities {
                        print(city.toString())
                    }
                    */
                    
                    self.overViewTable.reloadData()
                    self.refreshControl.endRefreshing()
                }
                else {
                    print("No cities found")
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                //get old data
                print("get old data instead")
                let db: DB = DB()
                if let db_Cities = db.getCites() {
                    self.cities = db_Cities
                }
                
                self.overViewTable.reloadData()
                self.refreshControl.endRefreshing()
            }
        }

    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        self.getWeatherDataToLocation(manager.location!.coordinate.latitude, lon: manager.location!.coordinate.longitude)
        
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
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func refresh(sender:AnyObject)
    {
        self.locationManager.startUpdatingLocation()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let cell = sender as? UITableViewCell
            let indexPath = overViewTable.indexPathForCell(cell!)
            let cityObject = self.cities[indexPath!.row]
            
            //let navController: UINavigationController = segue.destinationViewController as! UINavigationController;
            
            let detailVC = segue.destinationViewController as! DetailViewController
            detailVC.cityObject = cityObject 
            
            
            
            //player = Player(name: nameTextField.text!, game: "Chess", rating: 1)
        }
    }
    
    @IBAction func chooseRadius(sender: AnyObject) {
        let pickerFrame = CGRectMake(0, (self.view.frame.height/3) * 2, self.view.frame.width, (self.view.frame.height/3))
        
        let picker = UIPickerView(frame: pickerFrame)
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.grayColor()
        self.view.addSubview(picker)
        picker.selectRow(radiusOptions.indexOf(radius)!, inComponent: 0, animated: false)
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return radiusOptions.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.radiusOptions[row])"
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.radius = radiusOptions[row]
        self.locationManager.startUpdatingLocation()
        radiusButton.title = "Radius (\(radius))"
        pickerView.removeFromSuperview()
    }
    

}
