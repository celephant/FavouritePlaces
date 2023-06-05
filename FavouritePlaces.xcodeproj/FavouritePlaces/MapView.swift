//
//  MapView.swift
//  FavouritePlaces
//
//  Created by Ze Zeng on 13/5/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    // Binding to the coordinate that the map displays
    @Binding var coordinate: CLLocationCoordinate2D

    var body: some View {
        // Create a binding to the region that the map displays
        let region = Binding<MKCoordinateRegion>(
            get: {
                // Construct a region with the coordinate and a default span
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            },
            set: {
                // Update the coordinate when the region changes
                coordinate = $0.center
            }
        )
        
        // Return a Map view with the bound region and interaction modes
        return Map(coordinateRegion: region, interactionModes: .all)
            .onTapGesture {
                // Add functionality to handle tap gesture here.
            }
    }
}



