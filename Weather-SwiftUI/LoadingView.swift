//
//  LoadingView.swift
//  Weather-SwiftUI
//
//  Created by Jingwen Shi on 2022-12-25.
//

import SwiftUI

struct LoadingView: View {
    
    @EnvironmentObject var weatherManager: WeatherManager
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack{
                Text("- -").font(.system(size: 80)).bold().foregroundColor(.white)
                ProgressView(value: weatherManager.apiProgress, total: weatherManager.apiTotal).progressViewStyle(LinearProgressViewStyle())
            }
        }
        
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
