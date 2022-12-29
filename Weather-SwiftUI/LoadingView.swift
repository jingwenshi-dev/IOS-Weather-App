//
//  LoadingView.swift
//  Weather-SwiftUI
//
//  Created by Jingwen Shi on 2022-12-25.
//

import SwiftUI

struct LoadingView: View {
    
    @EnvironmentObject var weatherManager: WeatherManager
    
    @State private var progress: Double = 0
    
    @State private var showGlass = false
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()

            if weatherManager.apiProgress != 0 {
                ZStack{
                    RoundedRectangle(cornerRadius: 15, style: .circular)
                        .fill(.ultraThinMaterial)
                        .opacity(0.5)
                        .frame(width: 100, height: 100)
                    
                    ProgressView(value: progress, total: weatherManager.apiTotal)
                        .progressViewStyle(GaugeProgressStyle())
                        .scaleEffect(x: 0.15, y: 0.15, anchor: .center)
                        .contentShape(Rectangle())
                        .onReceive(weatherManager.$apiProgress){ _ in
                            if progress < weatherManager.apiTotal {
                                withAnimation {
                                    progress += weatherManager.apiProgress
                                }
                            }
                        }
                }
            }
        }
    }
}

// Copied from https://www.hackingwithswift.com/quick-start/swiftui/customizing-progressview-with-progressviewstyle
struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor = Color.blue
    var strokeWidth = 25.0
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return ZStack {
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
