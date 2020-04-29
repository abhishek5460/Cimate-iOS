//
//  WeatherManager.swift
//  Clima
//
//  Created by Abhishek Marriala on 15/04/20.
//  Copyright © 2020 Abhishek. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather:WeatherModel)
    func didError(error: Error)
}


struct WeatherManager {
    let weatherURL="https://api.openweathermap.org/data/2.5/weather?&appid=fcc894b8fadc21c047e82ca64efc3be4&units=metric"
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String)  {
        let urlString="\(weatherURL)&q=\(cityName)"
        performRequest(with : urlString)

    }
   
    func  fetchWeather(latitude : CLLocationDegrees, longitude : CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String){
        //step1 create url
        if let url = URL(string: urlString){
            // step 2 session
            let session = URLSession(configuration: .default)
            
            // step3
           // without closures let task=session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self , weather : weather)
                    }
                }
            }
            
            //step 4 starting
            task.resume()
        }
    }
    
//    func handle(data: Data?, response: URLResponse?, error: Error?)  {
//
//    }
    
    func parseJSON(_ weatherData: Data) ->WeatherModel?  {
        let decoder = JSONDecoder()
    do{
         let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
        let id = (decodedData.weather[0].id)
        let temp = decodedData.main.temp
        let name = decodedData.name
        
        let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            //print(weather.conditionName)
        return weather
        
        }
        catch{
            delegate?.didError(error: error)
            return nil
        }

    }
    
    
}

