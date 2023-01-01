//
//  WeatherView.swift
//  Weather-SwiftUI
//
//  Created by Jingwen Shi on 2022-12-26.
//

import SwiftUI
import SpriteKit

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

func getDayOfWeek(_ today:String) -> String? {
    let formatter  = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    guard let todayDate = formatter.date(from: today) else { return nil }
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDayNum = myCalendar.component(.weekday, from: todayDate)
    let weekDay = Calendar.current.weekdaySymbols[weekDayNum - 1]
    return weekDay
}

func getMainWeatherImages(data: WeatherData) -> Array<String> {
    
    var dict: [String: Array<Int>] = [:]
    var images: [String] = ["", "", "", "", "", "", ""]
    
    for i in 0..<40 {
        let date = String(data.list[i].dt_txt[0..<11])
        let weather = data.list[i].weather[0].main
        
        if dict[date] == nil {
            dict[date] = [0, 0, 0, 0, 0, 0, 0]
        }
        
        if var arr = dict[date] {
            if weather == "Thunderstorm"{
                arr[0] += 1
                dict[date] = arr
            }
            else if weather == "Drizzle"{
                arr[1] += 1
                dict[date] = arr
            }
            else if weather == "Rain" {
                arr[2] += 1
                dict[date] = arr
            }
            else if weather == "Snow" {
                arr[3] += 1
                dict[date] = arr
            }
            else if weather == "Clear" {
                arr[5] += 1
                dict[date] = arr
            }
            else if weather == "Clouds" {
                arr[6] += 1
                dict[date] = arr
            }
            else {
                arr[4] += 1
                dict[date] = arr
            }
        }
    }
    
    let dictSorted = dict.sorted( by: { $0.0 < $1.0 })
    
    var counter = 0
        
    for (_, arr) in dictSorted {
                
        var maxVal = arr[0]
        var index = 0
        var maxCounter = 0
        
        for num in arr {
            if num > maxVal {
                maxVal = num
                index = maxCounter
            }
            maxCounter += 1
        }
        
        if index == 0 {
            images[counter] = "cloud.bolt.rain.fill"
        }
        else if index == 1 {
            images[counter] = "cloud.drizzle.fill"
        }
        else if index == 2 {
            images[counter] = "cloud.rain.fill"
        }
        else if index == 3 {
            images[counter] = "snowflake.fill"
        }
        else if index == 4 {
            images[counter] = "cloud.fog.fill"
        }
        else if index == 5 {
            images[counter] = "sun.min.fill"
        }
        else {
            images[counter] = "cloud.fill"
        }
                
        counter += 1
        
    }
    return images
}

func getMinMaxTemp(data: WeatherData) -> Array<Array<Int>> {

    var dict: [String: Array<Int>] = [:]
    
    for i in 0..<40 {
        let date = String(data.list[i].dt_txt[0..<11])
        let min = data.list[i].main.temp_max
        let max = data.list[i].main.temp_min

        if dict[date] == nil {
            dict[date] = [0, 0]
        }

        if var arr = dict[date] {
            if arr[0] < Int(max) {
                arr[0] = Int(max)
            }
            if arr[1] > Int(min) {
                arr[1] = Int(min)
            }
            dict[date] = arr
        }
    }
    
    let dictSorted = dict.sorted( by: { $0.0 < $1.0 })

    var temps: Array<Array<Int>> = []
    
    for (_, arr) in dictSorted {
        temps.append(arr)
    }

    return temps
}


struct WeatherView: View {
    
    var data: WeatherData
    var unit: String = "°"
    
    var body: some View {
        
        ZStack{
            
            if data.list[0].weather[0].main == "Rain" {
                LinearGradient(gradient: Gradient(colors: [Color.gray, Color.clear]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                SpriteView(scene: RainFall(), options: [.allowsTransparency])
            }
            else if data.list[0].weather[0].main == "Snow" {
                LinearGradient(gradient: Gradient(colors: [Color.gray, Color.clear]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                SpriteView(scene: SnowFall(), options: [.allowsTransparency])
            }
            else {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.clear]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            
            ScrollView(showsIndicators: false){
                
                Spacer().frame(height: 100)
                Text(data.city.name).font(.system(size: 30, weight: .medium, design: .default)).foregroundColor(.white)
                Text("  \(Int(data.list[1].main.temp))\(unit)").font(.system(size: 100, weight: .light, design: .default)).bold().foregroundColor(.white)
                Text(data.list[1].weather[0].description.capitalized).font(.title3).foregroundColor(.white)
                HStack {
                    Text("H:\(Int(data.list[1].main.temp_max))\(unit)").font(.title3).foregroundColor(.white)
                    Text("L:\(Int(data.list[1].main.temp_min))\(unit)").font(.title3).foregroundColor(.white)
                }
                Spacer().frame(height: 50)
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 20, style: .circular)
                        .fill(.ultraThinMaterial)
                        .opacity(0.5)
                        .frame(width: 350, height: 180)
                        .preferredColorScheme(.dark)
                    
                    VStack(alignment: .leading){
                        Text("\(Image(systemName: "clock")) 3 HOUR FORECAST").font(.system(size: 12)).fontWeight(.semibold).foregroundColor(.white)
                        
                        Divider().overlay(.white)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack{
                                // Weather in the next 24h
                                ForEach(0..<25) {index in
                                    VStack {
                                        
                                        Text(String(data.list[index].dt_txt[11..<13])).foregroundColor(.white).padding(.bottom, 5)
                                        
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
                                            Text("\(Int(data.list[index].prob * 100))%").foregroundColor(Color(hue: 0.533, saturation: 0.53, brightness: 1.0)).bold()
                                        }
                                        else if data.list[index].weather[0].main == "Snow" {
                                            Image(systemName: "snowflake.fill").symbolRenderingMode(.multicolor).frame(width: 25, height: 25).font(.system(size: 25))
                                        }
                                        // Atmospheres
                                        else if (701...781).contains(data.list[index].weather[0].id) {
                                            Image(systemName: "cloud.fog.fill").symbolRenderingMode(.multicolor).frame(width: 25, height: 25).font(.system(size: 25))
                                        }
                                        else if data.list[index].weather[0].main == "Clear" {
                                            Image(systemName: "sun.min.fill").foregroundColor(Color(hue: 0.17, saturation: 1.0, brightness: 1.0)).frame(width: 25, height: 25).font(.system(size: 25)).padding(.vertical, 14)
                                        }
                                        // Clouds
                                        else {
                                            Image(systemName: "cloud.fill").symbolRenderingMode(.multicolor).frame(width: 25, height: 25).font(.system(size: 25)).padding(.vertical, 14)
                                        }
                                        Text("  \(Int(data.list[index].main.temp))\(unit)").font(.system(size: 20)).bold().foregroundColor(.white).padding(.top, 1)
                                    }.padding(.trailing, 16)
                                }
                            }
                        }
                    }.frame(maxWidth: 325)
                }
                
                Spacer().frame(height: 20)
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 20, style: .circular)
                        .fill(.ultraThinMaterial)
                        .opacity(0.5)
                        .frame(width: 350, height: 260)
                        .preferredColorScheme(.dark)
                    
                    VStack (alignment: .leading) {
                        Text("\(Image(systemName: "calendar")) 5-DAY FORECAST").font(.system(size: 12)).fontWeight(.semibold).foregroundColor(.white)
                        
                        if let images = getMainWeatherImages(data: data), let temps = getMinMaxTemp(data: data){
                            
                            ForEach(0..<5) {index in
                                Divider().overlay(.white)
                                
                                HStack {
                                    if index == 0 {
                                        Text("Today").font(.headline).foregroundColor(.white).frame(width: 55, alignment: .leading)
                                    } else {
                                        if let weekDay = getDayOfWeek(data.list[index*8].dt_txt) {
                                            Text(String(weekDay[0..<3])).font(.headline).foregroundColor(.white).frame(width: 55, alignment: .leading)
                                        }
                                    }
                                    
                                    if images[index] == "sun.min.fill" {
                                        Image(systemName: images[index]).symbolRenderingMode(.multicolor).foregroundColor(Color(hue: 0.17, saturation: 1.0, brightness: 1.0)).frame(width: 40)
                                    } else {
                                        Image(systemName: images[index]).symbolRenderingMode(.multicolor).frame(width: 40)
                                    }
                                    
                                    Text("\(Image(systemName: "thermometer.medium").symbolRenderingMode(.multicolor)) \(temps[index][1])\(unit) ~ \(temps[index][0])\(unit)").foregroundColor(Color.white).frame(width: 100, alignment: .leading).padding(.leading, 15)
                                    
                                    Text("\(Image(systemName: "wind").symbolRenderingMode(.multicolor)) \(Int(data.list[index * 8].wind.speed)) m/s").frame(alignment: .leading)
                                }
                            }
                        }
                    }.frame(maxWidth: 325)
                }
                
                Spacer().frame(height: 100)
                
            }.coordinateSpace(name: "SCROLL").ignoresSafeArea(.container, edges: .vertical)
            
        }
    }
    
  
}

class RainFall: SKScene {
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 1)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "Rain.sks")!
        addChild(node)
        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}

class SnowFall: SKScene {
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 1)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "Snow.sks")!
        addChild(node)
        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(data: WeatherData(cod: "200", message: 0, cnt: 40, list: [Weather_SwiftUI.WeatherData.list(dt: 1672466400, main: Weather_SwiftUI.WeatherData.list.main(temp: 15.36, feels_like: 15.28, temp_min: 14.02, temp_max: 15.36, pressure: 1013.0, sea_level: 1013.0, grnd_level: 1006.0, humidity: 89.0, temp_kf: 1.34), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 500, main: "Rain", description: "light rain", icon: "10n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 2.91, deg: 177, gust: 6.88), visibility: 3924, prob: 0.94, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 0.26)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2022-12-31 06:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672477200, main: Weather_SwiftUI.WeatherData.list.main(temp: 14.9, feels_like: 14.85, temp_min: 13.97, temp_max: 14.9, pressure: 1013.0, sea_level: 1013.0, grnd_level: 1004.0, humidity: 92.0, temp_kf: 0.93), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 500, main: "Rain", description: "light rain", icon: "10n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 3.45, deg: 172, gust: 9.81), visibility: 4332, prob: 0.87, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 0.5)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2022-12-31 09:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672488000, main: Weather_SwiftUI.WeatherData.list.main(temp: 14.54, feels_like: 14.53, temp_min: 14.13, temp_max: 14.54, pressure: 1010.0, sea_level: 1010.0, grnd_level: 1001.0, humidity: 95.0, temp_kf: 0.41), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 500, main: "Rain", description: "light rain", icon: "10n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 4.86, deg: 175, gust: 12.8), visibility: 1535, prob: 0.87, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 0.42)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2022-12-31 12:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672498800, main: Weather_SwiftUI.WeatherData.list.main(temp: 14.75, feels_like: 14.68, temp_min: 14.75, temp_max: 14.75, pressure: 1007.0, sea_level: 1007.0, grnd_level: 1000.0, humidity: 92.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 500, main: "Rain", description: "light rain", icon: "10n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 7.2, deg: 192, gust: 15.64), visibility: 8583, prob: 0.78, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 0.48)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2022-12-31 15:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672509600, main: Weather_SwiftUI.WeatherData.list.main(temp: 14.61, feels_like: 14.53, temp_min: 14.61, temp_max: 14.61, pressure: 1005.0, sea_level: 1005.0, grnd_level: 997.0, humidity: 92.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 500, main: "Rain", description: "light rain", icon: "10d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 8.43, deg: 180, gust: 16.85), visibility: 6587, prob: 0.91, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 1.63)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2022-12-31 18:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672520400, main: Weather_SwiftUI.WeatherData.list.main(temp: 14.18, feels_like: 14.08, temp_min: 14.18, temp_max: 14.18, pressure: 1000.0, sea_level: 1000.0, grnd_level: 993.0, humidity: 93.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 502, main: "Rain", description: "heavy intensity rain", icon: "10d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 8.09, deg: 192, gust: 18.83), visibility: 3069, prob: 1.0, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 16.57)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2022-12-31 21:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672531200, main: Weather_SwiftUI.WeatherData.list.main(temp: 11.91, feels_like: 11.51, temp_min: 11.91, temp_max: 11.91, pressure: 1001.0, sea_level: 1001.0, grnd_level: 993.0, humidity: 90.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 501, main: "Rain", description: "moderate rain", icon: "10d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 3.97, deg: 313, gust: 8.15), visibility: 10000, prob: 1.0, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 8.19)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2023-01-01 00:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672542000, main: Weather_SwiftUI.WeatherData.list.main(temp: 10.38, feels_like: 9.85, temp_min: 10.38, temp_max: 10.38, pressure: 1004.0, sea_level: 1004.0, grnd_level: 997.0, humidity: 91.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 500, main: "Rain", description: "light rain", icon: "10n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 2.58, deg: 286, gust: 8.16), visibility: 10000, prob: 0.98, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 1.46)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-01 03:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672552800, main: Weather_SwiftUI.WeatherData.list.main(temp: 9.6, feels_like: 8.26, temp_min: 9.6, temp_max: 9.6, pressure: 1006.0, sea_level: 1006.0, grnd_level: 999.0, humidity: 91.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 500, main: "Rain", description: "light rain", icon: "10n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 99), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 2.64, deg: 282, gust: 6.37), visibility: 10000, prob: 0.87, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 0.11)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-01 06:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672563600, main: Weather_SwiftUI.WeatherData.list.main(temp: 9.55, feels_like: 7.42, temp_min: 9.55, temp_max: 9.55, pressure: 1007.0, sea_level: 1007.0, grnd_level: 1000.0, humidity: 86.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 803, main: "Clouds", description: "broken clouds", icon: "04n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 53), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 4.06, deg: 303, gust: 8.99), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-01 09:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672574400, main: Weather_SwiftUI.WeatherData.list.main(temp: 8.42, feels_like: 7.45, temp_min: 8.42, temp_max: 8.42, pressure: 1009.0, sea_level: 1009.0, grnd_level: 1001.0, humidity: 91.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 802, main: "Clouds", description: "scattered clouds", icon: "03n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 38), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 1.89, deg: 296, gust: 4.48), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-01 12:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672585200, main: Weather_SwiftUI.WeatherData.list.main(temp: 7.68, feels_like: 6.51, temp_min: 7.68, temp_max: 7.68, pressure: 1011.0, sea_level: 1011.0, grnd_level: 1003.0, humidity: 92.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 800, main: "Clear", description: "clear sky", icon: "01n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 1), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 1.98, deg: 292, gust: 5.02), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-01 15:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672596000, main: Weather_SwiftUI.WeatherData.list.main(temp: 10.94, feels_like: 10.0, temp_min: 10.94, temp_max: 10.94, pressure: 1012.0, sea_level: 1012.0, grnd_level: 1004.0, humidity: 73.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 1), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 3.19, deg: 330, gust: 8.97), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2023-01-01 18:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672606800, main: Weather_SwiftUI.WeatherData.list.main(temp: 13.5, feels_like: 12.18, temp_min: 13.5, temp_max: 13.5, pressure: 1011.0, sea_level: 1011.0, grnd_level: 1004.0, humidity: 49.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 0), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 4.17, deg: 318, gust: 7.36), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2023-01-01 21:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672617600, main: Weather_SwiftUI.WeatherData.list.main(temp: 11.77, feels_like: 10.75, temp_min: 11.77, temp_max: 11.77, pressure: 1012.0, sea_level: 1012.0, grnd_level: 1004.0, humidity: 67.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 0), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 3.12, deg: 304, gust: 5.43), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2023-01-02 00:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672628400, main: Weather_SwiftUI.WeatherData.list.main(temp: 8.18, feels_like: 8.18, temp_min: 8.18, temp_max: 8.18, pressure: 1013.0, sea_level: 1013.0, grnd_level: 1006.0, humidity: 88.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 800, main: "Clear", description: "clear sky", icon: "01n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 3), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 0.78, deg: 212, gust: 1.24), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-02 03:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672639200, main: Weather_SwiftUI.WeatherData.list.main(temp: 7.6, feels_like: 7.6, temp_min: 7.6, temp_max: 7.6, pressure: 1015.0, sea_level: 1015.0, grnd_level: 1007.0, humidity: 89.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 801, main: "Clouds", description: "few clouds", icon: "02n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 15), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 1.08, deg: 234, gust: 1.28), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-02 06:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672650000, main: Weather_SwiftUI.WeatherData.list.main(temp: 7.28, feels_like: 6.73, temp_min: 7.28, temp_max: 7.28, pressure: 1014.0, sea_level: 1014.0, grnd_level: 1006.0, humidity: 89.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 1.35, deg: 125, gust: 1.74), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-02 09:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672660800, main: Weather_SwiftUI.WeatherData.list.main(temp: 7.29, feels_like: 6.49, temp_min: 7.29, temp_max: 7.29, pressure: 1014.0, sea_level: 1014.0, grnd_level: 1006.0, humidity: 88.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 1.56, deg: 148, gust: 2.09), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-02 12:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672671600, main: Weather_SwiftUI.WeatherData.list.main(temp: 7.28, feels_like: 6.37, temp_min: 7.28, temp_max: 7.28, pressure: 1014.0, sea_level: 1014.0, grnd_level: 1006.0, humidity: 89.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 1.66, deg: 153, gust: 2.67), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-02 15:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672682400, main: Weather_SwiftUI.WeatherData.list.main(temp: 9.15, feels_like: 7.63, temp_min: 9.15, temp_max: 9.15, pressure: 1014.0, sea_level: 1014.0, grnd_level: 1006.0, humidity: 86.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 2.78, deg: 179, gust: 5.64), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2023-01-02 18:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672693200, main: Weather_SwiftUI.WeatherData.list.main(temp: 9.16, feels_like: 6.9, temp_min: 9.16, temp_max: 9.16, pressure: 1010.0, sea_level: 1010.0, grnd_level: 1002.0, humidity: 89.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 500, main: "Rain", description: "light rain", icon: "10d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 4.15, deg: 145, gust: 8.99), visibility: 6273, prob: 0.93, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 2.16)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2023-01-02 21:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672704000, main: Weather_SwiftUI.WeatherData.list.main(temp: 7.74, feels_like: 5.15, temp_min: 7.74, temp_max: 7.74, pressure: 1007.0, sea_level: 1007.0, grnd_level: 999.0, humidity: 88.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 500, main: "Rain", description: "light rain", icon: "10d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 4.15, deg: 156, gust: 11.9), visibility: 10000, prob: 1.0, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 2.84)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2023-01-03 00:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672714800, main: Weather_SwiftUI.WeatherData.list.main(temp: 7.54, feels_like: 6.61, temp_min: 7.54, temp_max: 7.54, pressure: 1010.0, sea_level: 1010.0, grnd_level: 1003.0, humidity: 94.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 500, main: "Rain", description: "light rain", icon: "10n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 98), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 1.71, deg: 348, gust: 3.25), visibility: 9532, prob: 1.0, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 1.89)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-03 03:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672725600, main: Weather_SwiftUI.WeatherData.list.main(temp: 7.4, feels_like: 5.48, temp_min: 7.4, temp_max: 7.4, pressure: 1011.0, sea_level: 1011.0, grnd_level: 1003.0, humidity: 91.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 500, main: "Rain", description: "light rain", icon: "10n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 78), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 2.86, deg: 223, gust: 6.5), visibility: 10000, prob: 1.0, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 0.75)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-03 06:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672736400, main: Weather_SwiftUI.WeatherData.list.main(temp: 7.44, feels_like: 5.55, temp_min: 7.44, temp_max: 7.44, pressure: 1013.0, sea_level: 1013.0, grnd_level: 1005.0, humidity: 90.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 500, main: "Rain", description: "light rain", icon: "10n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 97), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 2.83, deg: 304, gust: 7.19), visibility: 10000, prob: 0.26, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 0.11)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-03 09:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672747200, main: Weather_SwiftUI.WeatherData.list.main(temp: 6.5, feels_like: 5.3, temp_min: 6.5, temp_max: 6.5, pressure: 1015.0, sea_level: 1015.0, grnd_level: 1007.0, humidity: 89.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 92), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 1.82, deg: 337, gust: 3.9), visibility: 10000, prob: 0.01, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-03 12:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672758000, main: Weather_SwiftUI.WeatherData.list.main(temp: 5.17, feels_like: 5.17, temp_min: 5.17, temp_max: 5.17, pressure: 1016.0, sea_level: 1016.0, grnd_level: 1008.0, humidity: 92.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 803, main: "Clouds", description: "broken clouds", icon: "04n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 55), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 0.59, deg: 65, gust: 0.65), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-03 15:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672768800, main: Weather_SwiftUI.WeatherData.list.main(temp: 8.24, feels_like: 8.24, temp_min: 8.24, temp_max: 8.24, pressure: 1018.0, sea_level: 1018.0, grnd_level: 1010.0, humidity: 79.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 803, main: "Clouds", description: "broken clouds", icon: "04d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 66), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 0.64, deg: 86, gust: 0.9), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2023-01-03 18:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672779600, main: Weather_SwiftUI.WeatherData.list.main(temp: 10.25, feels_like: 9.11, temp_min: 10.25, temp_max: 10.25, pressure: 1017.0, sea_level: 1017.0, grnd_level: 1010.0, humidity: 68.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 0.41, deg: 54, gust: 0.91), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2023-01-03 21:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672790400, main: Weather_SwiftUI.WeatherData.list.main(temp: 10.65, feels_like: 9.57, temp_min: 10.65, temp_max: 10.65, pressure: 1017.0, sea_level: 1017.0, grnd_level: 1010.0, humidity: 69.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 99), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 0.73, deg: 6, gust: 1.08), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2023-01-04 00:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672801200, main: Weather_SwiftUI.WeatherData.list.main(temp: 7.59, feels_like: 7.59, temp_min: 7.59, temp_max: 7.59, pressure: 1019.0, sea_level: 1019.0, grnd_level: 1011.0, humidity: 84.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 96), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 0.89, deg: 86, gust: 1.05), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-04 03:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672812000, main: Weather_SwiftUI.WeatherData.list.main(temp: 6.73, feels_like: 6.73, temp_min: 6.73, temp_max: 6.73, pressure: 1019.0, sea_level: 1019.0, grnd_level: 1011.0, humidity: 87.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 97), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 0.76, deg: 94, gust: 1.15), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-04 06:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672822800, main: Weather_SwiftUI.WeatherData.list.main(temp: 6.14, feels_like: 5.39, temp_min: 6.14, temp_max: 6.14, pressure: 1018.0, sea_level: 1018.0, grnd_level: 1010.0, humidity: 87.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 97), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 1.39, deg: 127, gust: 1.52), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-04 09:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672833600, main: Weather_SwiftUI.WeatherData.list.main(temp: 5.83, feels_like: 5.83, temp_min: 5.83, temp_max: 5.83, pressure: 1017.0, sea_level: 1017.0, grnd_level: 1009.0, humidity: 85.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 803, main: "Clouds", description: "broken clouds", icon: "04n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 63), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 0.99, deg: 121, gust: 1.16), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-04 12:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672844400, main: Weather_SwiftUI.WeatherData.list.main(temp: 5.43, feels_like: 4.37, temp_min: 5.43, temp_max: 5.43, pressure: 1016.0, sea_level: 1016.0, grnd_level: 1008.0, humidity: 85.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 802, main: "Clouds", description: "scattered clouds", icon: "03n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 25), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 1.55, deg: 115, gust: 2.08), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-04 15:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672855200, main: Weather_SwiftUI.WeatherData.list.main(temp: 9.31, feels_like: 8.59, temp_min: 9.31, temp_max: 9.31, pressure: 1015.0, sea_level: 1015.0, grnd_level: 1007.0, humidity: 69.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 803, main: "Clouds", description: "broken clouds", icon: "04d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 63), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 1.77, deg: 132, gust: 4.98), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2023-01-04 18:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672866000, main: Weather_SwiftUI.WeatherData.list.main(temp: 12.4, feels_like: 11.13, temp_min: 12.4, temp_max: 12.4, pressure: 1011.0, sea_level: 1011.0, grnd_level: 1003.0, humidity: 55.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 3.44, deg: 136, gust: 10.89), visibility: 10000, prob: 0.0, rain: nil, snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2023-01-04 21:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672876800, main: Weather_SwiftUI.WeatherData.list.main(temp: 10.57, feels_like: 9.54, temp_min: 10.57, temp_max: 10.57, pressure: 1008.0, sea_level: 1008.0, grnd_level: 1001.0, humidity: 71.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 500, main: "Rain", description: "light rain", icon: "10d")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 7.22, deg: 149, gust: 16.85), visibility: 9816, prob: 0.61, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 1.13)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "d"), dt_txt: "2023-01-05 00:00:00"), Weather_SwiftUI.WeatherData.list(dt: 1672887600, main: Weather_SwiftUI.WeatherData.list.main(temp: 10.89, feels_like: 10.41, temp_min: 10.89, temp_max: 10.89, pressure: 1007.0, sea_level: 1007.0, grnd_level: 1000.0, humidity: 91.0, temp_kf: 0.0), weather: [Weather_SwiftUI.WeatherData.list.weather(id: 502, main: "Rain", description: "heavy intensity rain", icon: "10n")], clouds: Weather_SwiftUI.WeatherData.list.clouds(all: 100), wind: Weather_SwiftUI.WeatherData.list.wind(speed: 6.68, deg: 148, gust: 15.97), visibility: 4678, prob: 1.0, rain: Optional(Weather_SwiftUI.WeatherData.list.rain(three_h: 12.76)), snow: nil, sys: Weather_SwiftUI.WeatherData.list.sys(pod: "n"), dt_txt: "2023-01-05 03:00:00")], city: Weather_SwiftUI.WeatherData.city(id: 5341145, name: "Cupertino", coord: Weather_SwiftUI.WeatherData.city.coord(lat: 37.3323, lon: -122.0312), country: "US", population: 58302, timezone: -28800, sunrise: 1672413715, sunset: 1672448354)))
    }
}
