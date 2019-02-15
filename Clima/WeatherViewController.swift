//
//  ViewController.swift
//  WeatherApp
//
//  Created by Atul Bansal on 14/02/19.
//  Copyright © 2019 Atul Bansal. All rights reserved.
//
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController,CLLocationManagerDelegate,ChangeCityDelegate {
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "82fab62ab71a62c0409fbb54ef65da09"
    
    //Instance variables Declared
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    func getWeatherData(url : String , params : [String : String])  {
        Alamofire.request(url, method : .get, parameters : params).responseJSON {
            response in
            if response.result.isSuccess {
                //print("Success!")
                let weatherJSON : JSON = JSON(response.result.value!)
                //print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                //print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Error"
                
            }
        }
    }

    //MARK: - JSON Parsing
    /***************************************************************/
    func updateWeatherData(json : JSON)  {
        if let tempResult = json["main"]["temp"].double {
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition )
            
            updateUIWithWeatherData()
        }
        else {
            cityLabel.text = "Weather Unavailable"
            
        }
    }

    //MARK: - UI Updates
    /***************************************************************/
    func updateUIWithWeatherData()  {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°C"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
    }
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locations = locations[locations.count - 1]
        if locations.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let latitude = String(locations.coordinate.latitude)
            let longitude = String(locations.coordinate.longitude)
            
            let parameters : [String : String] = ["lat" : latitude,"lon" : longitude ,"appid" : APP_ID]
            getWeatherData(url : WEATHER_URL, params : parameters)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable.."
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    func userEnteredANewCityName(city : String) {
        //print(city)
        
        let parameters : [String : String] = ["q" : city,"appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, params: parameters)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destionationVC = segue.destination as! ChangeCityViewController
            destionationVC.delegate = self
        }
    }
}
