//
//  ContentView.swift
//  JPMorgan-Coding-Exercise
//
//  Created by Ammar Chishti on 6/6/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some View {
        Button("Search Weather for City", action: {
            viewModel.searchWeather()
        })
        TextField(
                "Enter City Here",
                text: $viewModel.city
            )
        .textFieldStyle(.roundedBorder)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
