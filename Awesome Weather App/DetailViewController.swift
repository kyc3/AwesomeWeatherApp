//
//  DetailViewController.swift
//  Awesome Weather App
//
//  Created by Winter, Yannick on 04.03.16.
//  Copyright © 2016 Winter, Yannick. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var cityObject: City!
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    
    var image: UIImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = cityObject.name
        //navigationBar.topItem!.title = String(cityObject.valueForKey("name")!)
        
        temperatureLabel.text = cityObject.temperature + " °C"
        humidityLabel.text = cityObject.humidity + "%"
        pressureLabel.text = cityObject.pressure + "hPa"
        windspeedLabel.text = cityObject.windSpeed + " m/s"
        cloudinessLabel.text = cityObject.cloudiness + "%"
        weatherLabel.text = cityObject.weather
        weatherDescriptionLabel.text = cityObject.weatherDescription
        
        self.iconView.image = self.image
        
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
