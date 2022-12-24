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
        let apiKey = "???"
        let numDays = 7
        guard let URL = URL(string: "api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&cnt=\(numDays)&appid=\(apiKey)&units=imperial") else {fatalError("OpenWeather API URL Error")}
        
        let urlCall = URLRequest(url: URL)
    }
    
}
