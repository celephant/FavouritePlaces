//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Ze Zeng on 11/5/2023.
//

import SwiftUI
import MapKit

struct DetailView: View {
    // State for whether the view is in editing mode
    @State private var isEditing = false
    // Place object for the detail view
    @ObservedObject var place: Place
    // ViewModel for the detail view
    @ObservedObject var viewModel: PlaceViewModel
    // API for fetching sunrise and sunset times
    private let api = SunriseSunsetAPI()
    
    // State for the image URL, location, location details, latitude, longitude, image, sunrise, and sunset
    @State private var imageURL: String = ""
    @State private var location: String = ""
    @State private var locationDetails: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var image: Image = Image(systemName: "photo").resizable()
    @State private var sunrise: String = ""
    @State private var sunset: String = ""

    var body: some View {
        VStack {
            // Display or edit the image
            if isEditing {
                TextField("Image URL", text: $imageURL)
            } else {
                image
                    .resizable()
                    .scaledToFit()
            }

            // Display or edit the location
            if isEditing {
                TextField("Location", text: $location)
                
                // Geocode Address Button
                Button(action: {
                    viewModel.geocode(address: location) { result in
                        switch result {
                        case .success(let coordinate):
                            latitude = String(coordinate.latitude)
                            longitude = String(coordinate.longitude)
                            // Fetch sunrise and sunset times for the new location
                            fetchSunriseSunsetTimes()
                        case .failure(let error):
                            print("Failed to geocode address: \(error)")
                        }
                    }
                }) {
                    Text("🌍") // Replace button emoji
                }
            } else {
                Text(location)
            }

            // Display or edit the location details
            if isEditing {
                TextField("Location Details", text: $locationDetails)
            } else {
                Text(locationDetails)
            }

            // Display or edit the latitude
            if isEditing {
                TextField("Latitude", text: $latitude)
            } else {
                Text(latitude)
            }

            // Display or edit the longitude
            if isEditing {
                TextField("Longitude", text: $longitude)
            } else {
                Text(longitude)
            }
            
            // Map View , let String to Double
            if let lat = Double(latitude), let lon = Double(longitude) {
                MapView(coordinate: Binding(get: {
                    CLLocationCoordinate2D(latitude: lat, longitude: lon)
                }, set: { newCoordinate in
                    latitude = String(format: "%.8f", newCoordinate.latitude)
                    longitude = String(format: "%.8f", newCoordinate.longitude)
                    viewModel.reverseGeocode(coordinate: newCoordinate) { result in
                        switch result {
                        case .success(let locationName):
                            location = locationName
                        case .failure(let error):
                            print("Failed to reverse geocode coordinate: \(error)")
                        }
                    }
                }))
                .frame(height: 200)
                .cornerRadius(10)
                .padding(.vertical)
            }
            
            // Sunrise and Sunset times
            HStack {
                Text("☀️Sunrise: \(sunrise)")
                Spacer()
                Text("🌙Sunset: \(sunset)")
            }
            
            // Switch between view and edit modes
            Button(action: {
                if isEditing {
                    place.imageURL = imageURL
                    place.location = location
                    place.locationDetails = locationDetails
                    if let lat = Double(latitude), let lon = Double(longitude) {
                        place.latitude = lat
                        place.longitude = lon
                    }
                    loadImage()
                    Persistence.shared.saveData() // Save changes to Core Data context
                    viewModel.fetchPlaces() // Refresh the places array
                } else {
                    imageURL = place.imageURL ?? ""
                    location = place.location ?? ""
                    locationDetails = place.locationDetails ?? ""
                    latitude = String(format: "%.8f", place.latitude)
                    longitude = String(format: "%.8f", place.longitude)
                }
                isEditing.toggle()
            }) {
                Text(isEditing ? "Save" : "Edit")
            }

        }
        .padding()
        .onAppear {
            imageURL = place.imageURL ?? ""
            location = place.location ?? ""
            locationDetails = place.locationDetails ?? ""
            if let lat = Double(String(format: "%.8f", place.latitude)), let lon = Double(String(format: "%.8f", place.longitude)) {
                latitude = String(lat)
                longitude = String(lon)
            }
            loadImage()
            fetchSunriseSunsetTimes()
        }
    }

    
    
    
    
    // Function to load the image
    func loadImage() {
        Task {
            let downloadedImage = await viewModel.getImage(url: imageURL)
            image = downloadedImage
        }
    }
    
    // Function to fetch sunrise and sunset times
    func fetchSunriseSunsetTimes() {
        // Check if latitude and longitude can be converted to Double
        if let lat = Double(latitude), let lon = Double(longitude) {
            // Call the API to get sunrise and sunset times
            api.getSunriseSunsetTimes(latitude: lat, longitude: lon) { result in
                // Handle the result of the API call
                switch result {
                case .success(let times):
                    // Convert the sunrise and sunset times from UTC to local time
                    let localTimes = convertTimesToLocal(sunrise: times.sunrise, sunset: times.sunset)
                    // Update the state properties with the local times
                    sunrise = localTimes.sunrise
                    sunset = localTimes.sunset
                case .failure(let error):
                    print("Failed to get sunrise and sunset times: \(error)")
                }
            }
        }
    }

    
    // Function to convert sunrise and sunset times to local time
    func convertTimesToLocal(sunrise: String, sunset: String) -> (sunrise: String, sunset: String) {
        // Create a DateFormatter to parse the times
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC time

        // Parse the sunrise and sunset times as UTC dates
        let sunriseDate = dateFormatter.date(from: sunrise)
        let sunsetDate = dateFormatter.date(from: sunset)

        // Change the DateFormatter to convert the dates to local time
        dateFormatter.timeZone = TimeZone.current // Local time
        dateFormatter.dateFormat = "h:mm a"

        // Convert the dates to strings in local time
        let localSunrise = sunriseDate != nil ? dateFormatter.string(from: sunriseDate!) : ""
        let localSunset = sunsetDate != nil ? dateFormatter.string(from: sunsetDate!) : ""

        return (sunrise: localSunrise, sunset: localSunset)
    }
}


