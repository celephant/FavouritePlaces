//
//  MasterView.swift
//  FavouritePlaces
//
//  Created by Ze Zeng on 11/5/2023.
//

import SwiftUI

struct MasterView: View {
    // ViewModel that handles data operations
    @StateObject var viewModel: PlaceViewModel = PlaceViewModel()

    var body: some View {
        // NavigationView to support navigation between views
        NavigationView {
            List {
                ForEach(viewModel.places, id: \.self) { place in
                    NavigationLink(destination: DetailView(place: place, viewModel: viewModel)) {
                        // Display each place using the PlaceRow view
                        PlaceRow(place: place)
                    }
                }
                .onDelete(perform: viewModel.deletePlaces)
            }
            .navigationBarTitle("Favourite Places", displayMode: .inline)
            // Add a button to the navigation bar that adds a new place when tapped
            .navigationBarItems(trailing: Button(action: {
                viewModel.addPlace(location: "New Location", imageURL: "", locationDetails: "", latitude: 0, longitude: 0)
            }) {
                Image(systemName: "plus")
            })
        }
        // Fetch places from the ViewModel when the view appears
        .onAppear {
            viewModel.fetchPlaces()
        }
    }
}

