//
//  OpenWeather.swift
//  Weather-SwiftUI
//
//  Created by Jingwen Shi on 2022-12-23.
//

import Foundation
import CoreLocation

@MainActor class WeatherManager: ObservableObject {
    
    @Published var loaded: Bool = false
    @Published var weatherData: WeatherData? = nil
    @Published var observation: NSKeyValueObservation? = nil
    @Published internal var apiProgress: Double = 0
    internal var apiTotal: Double = 1
    
    func weatherApiCall(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        guard let APIKey = Bundle.main.object(forInfoDictionaryKey: "OpenWeather API Key") as? String else {
            fatalError("<OpenWeather API Key> does not exist in Info.plist.\nPlease add <value = YOUR API KEY> with <key = 'OpenWeather API Key'> manually.")
        }
        
        guard let URL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(APIKey)&units=metric") else {fatalError("OpenWeather API URL Error")}
        
        print(URL)
        
        let dataTask = URLSession.shared.dataTask(with: URL) { rawData, urlResponse, taskError in
            
            // If request failed
            if let taskError = taskError {
                fatalError(taskError.localizedDescription)
            }
            
            // If no data obtained, return nil
            guard let rawData = rawData else { return }
            
            // Check if data gained successfully
            let httpResponse = urlResponse as? HTTPURLResponse
            if !(200 <= httpResponse?.statusCode ?? -999 || httpResponse?.statusCode ?? -999 <= 300) {
                fatalError("Weather data fetching failed")
            }
            
            // Set weatherData when data is fetched and decoded
            do {
                let fetchedData = try JSONDecoder().decode(WeatherData.self, from: rawData)
                DispatchQueue.main.async {
                    self.weatherData = fetchedData
                }
            } catch {
                fatalError("JSONDecoder error: \(error)")
            }
        }
        
        observation = dataTask.progress.observe(\.fractionCompleted) { observationProgress, _ in
            DispatchQueue.main.async {
                self.apiProgress = observationProgress.fractionCompleted
//                print(self.apiProgress)
            }
        }

        dataTask.resume()

    }
}

struct WeatherData: Codable {
    
    var cod: String
    var message: Int
    var cnt: Int
    var list: [list]
    var city: city
    
    struct list: Codable {
        var dt: Int
        var main: main
        var weather: [weather]
        var clouds: clouds
        var wind: wind
        var visibility: Int
        var pop: Float
        var rain: rain?
        var snow: snow?
        var sys: sys
        var dt_txt: String
        
        struct main: Codable {
            var temp: Float
            var feels_like: Float
            var temp_min: Float
            var temp_max: Float
            var pressure: Float
            var sea_level: Float
            var grnd_level: Float
            var humidity: Float
            var temp_kf: Float
        }
        
        struct weather: Codable {
            var id: Int
            var main: String
            var description: String
            var icon: String
        }
        
        struct clouds: Codable {
            var all: Int
        }
        
        struct wind: Codable {
            var speed: Float
            var deg: Int
            var gust: Float
        }
        
        struct rain: Codable {
            // Convert json parameter 3h to three_h
            var three_h: Float
            enum CodingKeys: String, CodingKey {
                case three_h = "3h"
            }
        }
        
        struct snow: Codable {
            // Convert json parameter 3h to three_h
            var three_h: Float
             enum CodingKeys: String, CodingKey {
                case three_h = "3h"
            }
        }
        
        struct sys: Codable {
            var pod: String
        }
    }
    
    struct city: Codable {
        var id: Int
        var name: String
        var coord: coord
        var country: String
        var population: Int
        var timezone: Int
        var sunrise: Int
        var sunset: Int
        
        struct coord: Codable {
            var lat: Float
            var lon: Float
        }
    }
    
}
