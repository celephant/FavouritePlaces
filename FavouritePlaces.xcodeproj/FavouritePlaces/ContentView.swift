//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Ze Zeng on 30/4/2023.
//

import SwiftUI

struct ContentView: View {
    // Create an instance of PlaceViewModel
    @StateObject private var viewModel = PlaceViewModel()

    var body: some View {
        NavigationView {
            // Pass the viewModel to the MasterView
            MasterView(viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
