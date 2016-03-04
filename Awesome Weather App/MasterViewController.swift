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

class MasterViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate  {

    @IBOutlet weak var overViewTable: UITableView!
    var locationManager:CLLocationManager!
    var locationArray = []
    var refreshControl: UIRefreshControl!

    
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
        url = "http://api.openweathermap.org/data/2.5/find?lat=\(lat)&lon=\(lon)&cnt=4&units=metric&appid=44db6a862fba0b067b1930da0d769e98"
        Alamofire.request(.GET, url).responseJSON() {
            response in switch response.result {
            case .Success(let JSON):
                
                let response = JSON as! NSDictionary
                
                if (response.valueForKey("list") != nil) {
                    self.locationArray = response.valueForKey("list")! as! NSArray
                    self.overViewTable.reloadData()
                    self.refreshControl.endRefreshing()
                }
                else {
                    print("No cities found")
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }

    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        self.getWeatherDataToLocation(manager.location!.coordinate.latitude, lon: manager.location!.coordinate.longitude)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier( "Cell", forIndexPath: indexPath) as! WeatherOverviewCell
    
        let currentLocation = self.locationArray[indexPath.row]
        let mainObject = currentLocation.valueForKey("main") as! NSDictionary
        let windObject = currentLocation.valueForKey("wind") as! NSDictionary
        cell.cityNameLab?.text =  currentLocation.valueForKey("name") as? String
        cell.temperatureLabel?.text = String(mainObject.valueForKey("temp")!) + " °C"
        cell.humidityLabel?.text = String(mainObject.valueForKey("humidity")!) + "%"
        cell.windspeedLabel?.text = String(windObject.valueForKey("speed")!) + " m/s"
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func refresh(sender:AnyObject)
    {
        self.locationManager.startUpdatingLocation()
        
    }

}
