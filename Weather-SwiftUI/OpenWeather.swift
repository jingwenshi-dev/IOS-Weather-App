//
//  OpenWeather.swift
//  Weather-SwiftUI
//
//  Created by Jingwen Shi on 2022-12-23.
//

import Foundation
import CoreLocation

class WeatherManager {
    
    func weatherApiCall(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let numDays = 7
        
        guard let APIKey = Bundle.main.object(forInfoDictionaryKey: "OpenWeather API Key") as? String else {
            fatalError("OpenWeather API Key does not exist.\nPlease add your API key as <value> to Info.plist with <key: 'OpenWeather API Key'> ")
        }

        guard let URL = URL(string: "api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&cnt=\(numDays)&appid=\(APIKey)&units=imperial") else {fatalError("OpenWeather API URL Error")}
        
        let urlCall = URLRequest(url: URL)
    }
    
}
