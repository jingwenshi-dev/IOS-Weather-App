//
//  ContentView.swift
//  Weather-SwiftUI
//
//  Created by Jingwen Shi on 2022-12-23.
//

import SwiftUI

struct ContentView: View {

    @State var observation: NSKeyValueObservation?
    @State var weatherData: WeatherData?
    
    @State var apiProgress: Double = 0
    let apiTotal: Double = 1

    @StateObject private var loctionManager = LocationDataManager()
    @StateObject private var weatherManager = WeatherManager(weatherData: weatherData, observation: observation, apiProgress: apiProgress)
    
    var body: some View {
        
        if loctionManager.location == nil {
            LoadingView(apiProgress: apiProgress, apiTotal: apiTotal)
                .task{loctionManager.isSystemLocationServiceEnabled()
                }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
