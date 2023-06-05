//
//  PlaceViewModel.swift
//  FavouritePlaces
//
//  Created by Ze Zeng on 10/5/2023.
//

import Foundation
import CoreData
import SwiftUI
import CoreLocation

// ViewModel for managing Place objects
class PlaceViewModel: ObservableObject {
    // Published array of Place objects
    @Published var places: [Place] = []

    // Private instances of Core Data context and CLGeocoder
    private let context = Persistence.shared.container.viewContext
    private let geocoder = CLGeocoder()

    // Function to fetch Place objects from Core Data
    func fetchPlaces() {
        do {
            self.places = try context.fetch(Place.fetchRequest())
            print("Fetched places: \(self.places)") // Print statement to check fetched places
        } catch {
            print("Failed to fetch places: \(error)") // Print statement to check if there's an error
        }
    }

    // Function to add a new Place object to Core Data
    func addPlace(location: String, imageURL: String, locationDetails: String, latitude: Double, longitude: Double) {
        let place = Place(context: context)
        place.location = location
        place.imageURL = imageURL
        place.locationDetails = locationDetails
        place.latitude = latitude
        place.longitude = longitude

        do {
            try context.save()
            print("Place added successfully") // Debugging print statement
        } catch {
            print("Failed to add place: \(error)") // Debugging print statement
        }
        fetchPlaces()
    }

    // Function to delete Place objects from Core Data
    func deletePlaces(at offsets: IndexSet) {
        for index in offsets {
            let place = places[index]
            context.delete(place)
        }
        do {
            try context.save()
        } catch {
            print("Failed to delete place: \(error)") // Debugging print statement
        }
        fetchPlaces()
    }
    

    // Default image and dictionary to store downloaded images
    let defaultImage = Image(systemName: "photo").resizable()
    var downloadImages: [URL: Image] = [:]

    // Function to asynchronously download an image from a URL
    func getImage(url: String) async -> Image {
        guard let imageURL = URL(string: url) else {
            return defaultImage
        }

        if let image = downloadImages[imageURL] {
            return image
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            guard let uiImage = UIImage(data: data) else {
                return defaultImage
            }
            let image = Image(uiImage: uiImage).resizable()
            downloadImages[imageURL] = image
            return image
        } catch {
            print("Error downloading image: \(error)")
        }

        return defaultImage
  
    }
    
    // Function to geocode an address string into a CLLocationCoordinate2D
    func geocode(address: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let location = placemarks?.first?.location {
                    completion(.success(location.coordinate))
                }
            }
        }
    }

    // Function to reverse geocode a CLLocationCoordinate2D into a location name
    func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<String, Error>) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let placemark = placemarks?.first {
                    let locationName = [
                        placemark.locality,
                        placemark.administrativeArea,
                        placemark.country
                    ].compactMap { $0 }.joined(separator: ", ")
                    completion(.success(locationName))
                }
            }
        }
    }
}
