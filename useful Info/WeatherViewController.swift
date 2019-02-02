//
//  WeatherViewController.swift
//  useful Info
//
//  Created by Daniel Furrer on 07.12.18.
//  Copyright © 2018 Daniel Furrer. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var faren: UISwitch!
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast"
    let APP_ID = "7f8f1f24260fdd6c4a09d137afa97fd9"
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBAction func `switch`(_ sender: UISwitch) {
        
        if sender.isOn {
            
        }
    }
    
    
    /***********************IBOutlets********************/
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var lbldateFor1: UILabel!
    @IBOutlet weak var lbltempFor1: UILabel!
    @IBOutlet weak var imgFor1: UIImageView!
    @IBOutlet weak var lbldateFor2: UILabel!
    @IBOutlet weak var lbltempFor2: UILabel!
    @IBOutlet weak var imgFor2: UIImageView!
    @IBOutlet weak var lbldateFor3: UILabel!
    @IBOutlet weak var lbltempFor3: UILabel!
    @IBOutlet weak var imgFor3: UIImageView!
    @IBOutlet weak var lbldateFor4: UILabel!
    @IBOutlet weak var lbltempFor4: UILabel!
    @IBOutlet weak var imgFor4: UIImageView!
    @IBOutlet weak var lbldateFor5: UILabel!
    @IBOutlet weak var lbltempFor5: UILabel!
    @IBOutlet weak var imgFor5: UIImageView!
    @IBOutlet weak var lbldateFor6: UILabel!
    @IBOutlet weak var lbltempFor6: UILabel!
    @IBOutlet weak var imgFor6: UIImageView!
    
    
    
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - Networking
    /***************************************************************/
    /******************Current Weather******************************/
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                //print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    //******************GET FORECAST***********
    func getWeatherForececast(url: String, parameters: [String: String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            (response) in
            if response.result.isSuccess {
                print("Success! Got the forecast data")
                let forecastJSON : JSON = JSON(response.result.value!)
                print(forecastJSON)
                self.updateForecastDate(jsonForecast: forecastJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    func updateWeatherData(json : JSON) {
        
        let dateResult = json["dt_text"].stringValue
        let tempResult = json["main"]["temp"].doubleValue
        
        weatherDataModel.city = String(dateResult)
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.city = json["name"].stringValue
        
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        
        
        updateUIWithWeatherData()
    }

    
    func updateForecastDate(jsonForecast : JSON) {
        
        let arrayForDates =  jsonForecast["list"].arrayValue.map({$0["dt_txt"].stringValue})
        let dateFor1 = arrayForDates[3]
        let dateFor2 = arrayForDates[6]
        let dateFor3 = arrayForDates[9]
        let dateFor4 = arrayForDates[12]
        let dateFor5 = arrayForDates[15]
        let dateFor6 = arrayForDates[18]
        
        let arrayForWeather =  jsonForecast["list"].arrayValue.map({$0["main"]["temp"].doubleValue})
        let arrayForIcon =  jsonForecast["list"].arrayValue.map({$0["weather"][0]["id"].intValue})
        
        //print(arrayForWeather)
        //print(arrayForIcon)
        
        /****Forecast 1****/
        let tempFor1 = arrayForWeather[3] - 273.15
        let iconForId1 = arrayForIcon[3]
        let iconForName1 = ForecastIcon(condition: iconForId1)
        //let weekDay = getWeekDay(myDate: String(dateFor1.prefix(10)))
        lbldateFor1.text = String(dateFor1.prefix(16))
        lbltempFor1.text = String.localizedStringWithFormat("%.0f %@", tempFor1, "°")
        imgFor1.image = UIImage(named: iconForName1)
        /****Forecast 2****/
        let tempFor2 = arrayForWeather[6] - 273.15
        let iconForId2 = arrayForIcon[6]
        let iconForName2 = ForecastIcon(condition: iconForId2)
        lbldateFor2.text = String(dateFor2.prefix(16))
        lbltempFor2.text = String.localizedStringWithFormat("%.0f %@", tempFor2, "°")
        imgFor2.image = UIImage(named: iconForName2)
        /****Forecast 3****/
        let tempFor3 = arrayForWeather[9] - 273.15
        let iconForId3 = arrayForIcon[9]
        let iconForName3 = ForecastIcon(condition: iconForId3)
        lbldateFor3.text = String(dateFor3.prefix(16))
        lbltempFor3.text = String.localizedStringWithFormat("%.0f %@", tempFor3, "°")
        imgFor3.image = UIImage(named: iconForName3)
        /****Forecast 4****/
        let tempFor4 = arrayForWeather[12] - 273.15
        let iconForId4 = arrayForIcon[12]
        let iconForName4 = ForecastIcon(condition: iconForId4)
        lbldateFor4.text = String(dateFor4.prefix(16))
        lbltempFor4.text = String.localizedStringWithFormat("%.0f %@", tempFor4, "°")
        imgFor4.image = UIImage(named: iconForName4)
        /****Forecast 5****/
        let tempFor5 = arrayForWeather[15] - 273.15
        let iconForId5 = arrayForIcon[15]
        let iconForName5 = ForecastIcon(condition: iconForId5)
        lbldateFor5.text = String(dateFor5.prefix(16))
        lbltempFor5.text = String.localizedStringWithFormat("%.0f %@", tempFor5, "°")
        imgFor5.image = UIImage(named: iconForName5)
        /****Forecast 6****/
        let tempFor6 = arrayForWeather[18] - 273.15
        let iconForId6 = arrayForIcon[18]
        let iconForName6 = ForecastIcon(condition: iconForId6)
        lbldateFor6.text = String(dateFor6.prefix(16))
        lbltempFor6.text = String.localizedStringWithFormat("%.0f %@", tempFor6, "°")
        imgFor6.image = UIImage(named: iconForName6)
        
        
        
    }
    

    
    func dateToString(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let newDate = dateFormatter.string(from: date)
        return newDate
        
    }
    
    func getWeekDay(myDate:String) -> Int {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let myDateF = dateFormatter.date(from: myDate)
        let weekday = Calendar.current.component(.weekday, from: myDateF!)
        
        return weekday
        
    
    
    }

    func ForecastIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "tstorm"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower"
            
        case 601...700 :
            return "snow"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy"
            
        case 900...903, 905...1000  :
            return "tstorm"
            
        case 903 :
            return "snow"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
        
    }
    
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    func updateUIWithWeatherData() {
        
        lblCity.text = weatherDataModel.city
        cityLabel.text = "Current weather"
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
    }
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            self.locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
            getWeatherForececast(url: FORECAST_URL, parameters: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
 
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    func userEnteredANewCityName(city: String) {
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        
    }

}

class ForecastDataModel {
    var title = ""
    var urlToImage = ""
    var url = ""
    var description = ""
   
}
