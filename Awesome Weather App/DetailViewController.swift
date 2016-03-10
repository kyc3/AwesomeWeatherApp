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
        self.title = self.cityObject.name
        //navigationBar.topItem!.title = String(self.cityObject.valueForKey("name")!)
        self.temperatureLabel.text = self.cityObject.temperature + " °C"
        self.humidityLabel.text = self.cityObject.humidity + "%"
        self.pressureLabel.text = self.cityObject.pressure + "hPa"
        self.windspeedLabel.text = self.cityObject.windSpeed + " m/s"
        self.cloudinessLabel.text = self.cityObject.cloudiness + "%"
        self.weatherLabel.text = self.cityObject.weather
        self.weatherDescriptionLabel.text = self.cityObject.weatherDescription
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
