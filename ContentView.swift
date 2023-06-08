//
//  ContentView.swift
//  JPMorgan-Coding-Exercise
//
//  Created by Ammar Chishti on 6/6/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel()
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack {
            Button("Search Weather for City", action: {
                Task {
                        await viewModel.searchWeather()
                    }
            })
            
            TextField(
                    "Enter City Here",
                    text: $viewModel.city
                )
            .textFieldStyle(.roundedBorder)
            
            NavigationView {
                if (horizontalSizeClass == .compact) {
                    VStack {
                        if let weatherData = viewModel.weatherData {
                            WeatherDetailView(weatherData: weatherData, city: viewModel.city).navigationTitle("Ammar Weather App")
                        } else if let weatherDataError = viewModel.weatherDataError {
                            Text(weatherDataError.message)
                        }
                    }.navigationTitle("Ammar Weather App")
                } else {
                    HStack {
                        if let weatherData = viewModel.weatherData {
                            WeatherDetailView(weatherData: weatherData, city: viewModel.city).navigationTitle("Ammar Weather App")
                        } else if let weatherDataError = viewModel.weatherDataError {
                            Text(weatherDataError.message)
                        }
                    }.navigationTitle("Ammar Weather App")
                }
            }
        }
        .onAppear {
            print("Checking if we have the last loaded city in cache")
            // I did not have enough time to get the city from the long/latitude coordinates. Long term I would plan to use reverseGeocodeLocation https://developer.apple.com/documentation/corelocation/clgeocoder/1423621-reversegeocodelocation
//            if (viewModel.location != nil) {
//                viewModel.city = "Boston"
//                Task {
//                    await viewModel.searchWeather()
//                }
            
            if let city = UserDefaults.standard.string(forKey: "City") {
                viewModel.city = city
                Task {
                    await viewModel.searchWeather()
                }
            }
    
            print("Requesting location if not done already")
            viewModel.requestLocation()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WeatherDetailView: View {
    let weatherData: WeatherObject
    let city: String
    
    var body: some View {
        VStack {
            Text("Weather for \(city)")
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon)@2x.png")!)
            Text("Weather: \(weatherData.weather[0].main)")
            Text("Weather Description: \(weatherData.weather[0].description)")
            Text("Temperature: \(weatherData.main.temp) Degrees Fahrenheit")
            Text("Humidity: \(weatherData.main.humidity)")
        }
    }
}
