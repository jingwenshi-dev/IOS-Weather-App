//
//  ContentView.swift
//  Weather-SwiftUI
//
//  Created by Jingwen Shi on 2022-12-23.
//

import SwiftUI

struct ContentView: View {
        
    @StateObject var locationManager = LocationDataManager()
    @StateObject var weatherManager = WeatherManager()
    
    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            if locationManager.loaded {
                if let weatherData = weatherManager.weatherData{
                    WeatherView(weatherData: weatherData)
                }
                else {
                    LoadingView().environmentObject(weatherManager).task {
                        guard let location = locationManager.location else {fatalError("Location data access failure")}
                        weatherManager.weatherApiCall(latitude: location.latitude, longitude: location.longitude)
                        print("Accessing Weather Data ... ")
                    }
                }
            }
            else {
                if !(locationManager.loaded) {
                    LoadingView().environmentObject(weatherManager).task{
                        locationManager.isSystemLocationServiceEnabled()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
