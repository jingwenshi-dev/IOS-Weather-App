//
//  ContentView.swift
//  Weather-SwiftUI
//
//  Created by Jingwen Shi on 2022-12-23.
//

import SwiftUI

struct ContentView: View {
    
    @State var weatherData: WeatherData?
    
    @StateObject var locationManager = LocationDataManager()
    @StateObject var weatherManager = WeatherManager()
    
    //    @State var apiProgress: Double = 0
    //    @State var apiTotal: Double = 1
    
    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            if locationManager.loaded {
                if weatherData != nil{
                    WeatherView(weatherManager: weatherManager)
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
