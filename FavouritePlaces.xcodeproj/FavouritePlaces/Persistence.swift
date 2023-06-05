//
//  Persistence.swift
//  FavouritePlaces
//
//  Created by Ze Zeng on 30/4/2023.
//

import CoreData

struct Persistence {
    // Shared instance of Persistence
    static let shared = Persistence()
    let container: NSPersistentContainer

    // Initializer for Persistence
    init() {
        // Create a persistent container
        container = NSPersistentContainer(name: "Model")
        
        // Load the persistent stores
        container.loadPersistentStores { _, error in
            // If there is an error loading the persistent stores, print the error and terminate the app
            if let e = error {
                fatalError("Error loading data \(e).")
            }
        }
    }

    // Function to fetch places from Core Data
    func fetchPlaces() -> [Place] {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        
        do {
            // Try to fetch the places and return them
            return try container.viewContext.fetch(request)
        } catch {
            // If there is an error fetching the places, print the error and return an empty array
            print("Error fetching places: \(error)")
            return []
        }
    }

    // Function to add a place to Core Data
    func addPlace(location: String, imageURL: String, locationDetails: String, latitude: Double, longitude: Double) {
        // Create a new Place
        let newPlace = Place(context: container.viewContext)
        newPlace.location = location
        newPlace.imageURL = imageURL
        newPlace.locationDetails = locationDetails
        newPlace.latitude = latitude
        newPlace.longitude = longitude

        saveData()
    }

    // Function to update a place in Core Data
    func updatePlace(place: Place) {
        saveData()
    }

    // Function to delete a place from Core Data
    func deletePlace(place: Place) {
        // Delete the place
        container.viewContext.delete(place)
        saveData()
    }

    // Function to save the data
    func saveData() {
        // If there are changes in the context
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                // If there is an error saving the context, print the error
                print("Error saving data: \(error)")
            }
        }
    }
}

