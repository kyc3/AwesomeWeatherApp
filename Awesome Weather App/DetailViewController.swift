//
//  DetailViewController.swift
//  Awesome Weather App
//
//  Created by Winter, Yannick on 04.03.16.
//  Copyright © 2016 Winter, Yannick. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var cityObject: NSDictionary!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainObject = cityObject.valueForKey("main") as! NSDictionary
        let windObject = cityObject.valueForKey("wind") as! NSDictionary
        let cloudObject = cityObject.valueForKey("clouds") as! NSDictionary
        let weatherObject = cityObject.valueForKey("weather")?.objectAtIndex(0) as! NSDictionary
        
        self.title = String(cityObject.valueForKey("name")!)
        //navigationBar.topItem!.title = String(cityObject.valueForKey("name")!)
        
        temperatureLabel.text = String(mainObject.valueForKey("temp")!) + " °C"
        humidityLabel.text = String(mainObject.valueForKey("humidity")!) + "%"
        pressureLabel.text = String(mainObject.valueForKey("pressure")!) + "hPa"
        windspeedLabel.text = String(windObject.valueForKey("speed")!) + " m/s"
        cloudinessLabel.text = String(cloudObject.valueForKey("all")!) + "%"
        weatherLabel.text = String(weatherObject.valueForKey("main")!)
        weatherDescriptionLabel.text = String(weatherObject.valueForKey("description")!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
}
