//
//  ContentView.swift
//  Weather-SwiftUI
//
//  Created by Jingwen Shi on 2022-12-23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var loctionManager = LocationDataManager()
    
    var weather = WeatherManager()
    
    var body: some View {
        Text("Test Test").onAppear {
            loctionManager.isSystemLocationServiceEnabled()
            weather.weatherApiCall(latitude: loctionManager.location?.latitude ?? 1, longitude: loctionManager.location?.longitude ?? 1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
