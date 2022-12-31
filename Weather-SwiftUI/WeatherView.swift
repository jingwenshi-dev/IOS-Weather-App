//
//  WeatherView.swift
//  Weather-SwiftUI
//
//  Created by Jingwen Shi on 2022-12-26.
//

import SwiftUI

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}

struct WeatherView: View {
    
    var data: WeatherData
    var unit: String = "°"
    
    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            ScrollView(showsIndicators: false){
                
                Text(data.city.name).font(.system(size: 30, weight: .medium, design: .default)).foregroundColor(.white)
                Text("  \(Int(data.list[1].main.temp))\(unit)").font(.system(size: 100, weight: .light, design: .default)).bold().foregroundColor(.white)
                Text(data.list[1].weather[0].description.capitalized).font(.title3).foregroundColor(.white)
                
                HStack {
                    Text("H:\(Int(data.list[1].main.temp_max))\(unit)").font(.title3).foregroundColor(.white)
                    Text("L:\(Int(data.list[1].main.temp_min))\(unit)").font(.title3).foregroundColor(.white)
                }
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 20, style: .circular)
                        .fill(.ultraThinMaterial)
                        .opacity(0.5)
                        .frame(width: 350, height: 180)
                    
                    VStack(alignment: .leading){
                        Text("\(Image(systemName: "clock")) 3 HOUR FORECAST").font(.system(size: 12)).fontWeight(.semibold).foregroundColor(.white).padding(.horizontal, 10)
                        
                        Divider().overlay(.gray)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack{
                                ForEach(0..<25) {index in
                                    VStack {
                                        if index == 0 {
                                            Text("Now").bold().foregroundColor(.white).padding(.bottom, 5)
                                        }
                                        else {
                                            Text(String(data.list[index].dt_txt[11..<13])).foregroundColor(.white).padding(.bottom, 5)
                                        }
                                        
                                        if data.list[index].weather[0].main == "Thunderstorm" {
                                            if (210...221).contains(data.list[index].weather[0].id) {
                                                Image(systemName: "cloud.bolt.fill").symbolRenderingMode(.multicolor).frame(width: 25, height: 25).font(.system(size: 25))
                                            }
                                            else {
                                                Image(systemName: "cloud.bolt.rain.fill").symbolRenderingMode(.multicolor).frame(width: 25, height: 25).font(.system(size: 25))
                                            }
                                        }
                                        else if data.list[index].weather[0].main == "Drizzle" {
                                            Image(systemName: "cloud.drizzle.fill").symbolRenderingMode(.multicolor).frame(width: 25, height: 25).font(.system(size: 25))
                                        }
                                        else if data.list[index].weather[0].main == "Rain" {
                                            if data.list[index].weather[0].id == 500 {
                                                Image(systemName: "cloud.drizzle.fill").symbolRenderingMode(.multicolor).font(.system(size: 25))
                                            }
                                            else if data.list[index].weather[0].id == 501 || data.list[index].weather[0].id == 520 {
                                                Image(systemName: "cloud.rain.fill").symbolRenderingMode(.multicolor).font(.system(size: 25))
                                            }
                                            else {
                                                Image(systemName: "cloud.heavyrain.fill").symbolRenderingMode(.multicolor).font(.system(size: 25))
                                            }
                                            Text("\(Int(data.list[index].prob * 100))%").foregroundColor(Color(hue: 0.561, saturation: 0.675, brightness: 0.967)).bold()
                                        }
                                        else if data.list[index].weather[0].main == "Snow" {
                                            Image(systemName: "snowflake.fill").symbolRenderingMode(.multicolor).frame(width: 25, height: 25).font(.system(size: 25))
                                        }
                                        // Atmospheres
                                        else if (701...781).contains(data.list[index].weather[0].id) {
                                            Image(systemName: "cloud.fog.fill").symbolRenderingMode(.multicolor).frame(width: 25, height: 25).font(.system(size: 25))
                                        }
                                        else if data.list[index].weather[0].main == "Clear" {
                                            Image(systemName: "sun.min.fill").foregroundStyle(.yellow).frame(width: 25, height: 25).font(.system(size: 25)).padding(.vertical, 14)
                                        }
                                        // Clouds
                                        else {
                                            Image(systemName: "cloud.fill").symbolRenderingMode(.multicolor).frame(width: 25, height: 25).font(.system(size: 25)).padding(.vertical, 14)
                                        }
                                        Text("  \(Int(data.list[index].main.temp))\(unit)").font(.system(size: 20)).bold().foregroundColor(.white).padding(.top, 1)
                                    }.padding(.horizontal, 10)
                                }
                            }
                        }
                    }.frame(maxWidth: 325)
                    
//                    VStack (alignment: .leading) {
//                        
//                        
//                        
//                    }
                    
                }
            }
        }
    }
}
    
//struct WeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeatherView()
//    }
//}
