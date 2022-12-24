//
//  ContentView.swift
//  Weather-SwiftUI
//
//  Created by Jingwen Shi on 2022-12-23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var loctionManager = LocationDataManager()
    
    var body: some View {
        Text("Test Test").onAppear {
            loctionManager.isSystemLocationServiceEnabled()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
