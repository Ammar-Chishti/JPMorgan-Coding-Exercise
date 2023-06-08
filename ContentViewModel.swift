//
//  ContentViewModel.swift
//  JPMorgan-Coding-Exercise
//
//  Created by Ammar Chishti on 6/6/23.
//

import SwiftUI
import CoreLocation
import CoreLocationUI
import Foundation

class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var city: String = ""
    @Published var location: CLLocationCoordinate2D?
    @Published var weatherData: WeatherObject?
    @Published var weatherDataError: WeatherObjectError?
    
    let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print("Error occurred ")
        print(error)
    }
    
    @MainActor
    func searchWeather() async {

        // Normally I would not put my api key in the url like this but for the convenience of time I did.
        // If given enough time, I would use a secrets manager https://medium.com/tumiya/secrets-management-for-ios-apps-8fbc38c479c7
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(self.city)&appid=4daab81f7e918e5c6eb2236e9225326a")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let dataString = String(data: data, encoding: .utf8)!
            
            // If given enough time, I would have all of these String messages be placed into a constants file
            // This could be done cleaner using a a switch case and maybe one weatherData object instead of two
            if (dataString.contains("Nothing to geocode")) {
                self.weatherDataError = WeatherObjectError(message: "You cannot enter in a blank city. Try again")
                self.weatherData = nil
            } else if (dataString.contains("city not found")) {
                self.weatherDataError = WeatherObjectError(message: "Please enter in a valid city")
                self.weatherData = nil
            } else {
                self.weatherData = try JSONDecoder().decode(WeatherObject.self, from: data)
                UserDefaults.standard.set(self.city, forKey: "City")
            }
        } catch {
            print("ERROR")
            print(error)
            self.weatherDataError = WeatherObjectError(message: error.localizedDescription)
        }
    }
}
