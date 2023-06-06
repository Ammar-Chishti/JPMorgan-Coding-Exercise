//
//  ContentViewModel.swift
//  JPMorgan-Coding-Exercise
//
//  Created by Ammar Chishti on 6/6/23.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var city: String = ""

    func searchWeather() {
        print(city)
    }
}
