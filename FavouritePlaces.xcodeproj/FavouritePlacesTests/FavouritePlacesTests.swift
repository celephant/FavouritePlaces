//
//  FavouritePlacesTests.swift
//  FavouritePlacesTests
//
//  Created by Ze Zeng on 30/4/2023.
//

import XCTest
@testable import FavouritePlaces

final class FavouritePlacesTests: XCTestCase {

    // Test to check if the Place model is working correctly
    func testPlaceModel() {
        let place = Place(context: Persistence.shared.container.viewContext)
        // Set the properties of the Place object
        place.location = "Test Location"
        place.imageURL = "Test URL"
        place.locationDetails = "Test Details"
        place.latitude = 0.0
        place.longitude = 0.0

        // Assert that the properties of the Place object are correctly set
        XCTAssertEqual(place.location, "Test Location")
        XCTAssertEqual(place.imageURL, "Test URL")
        XCTAssertEqual(place.locationDetails, "Test Details")
        XCTAssertEqual(place.latitude, 0.0)
        XCTAssertEqual(place.longitude, 0.0)
    }
    
    
    
    // Test to check if the deletePlaces function in the ViewModel is working correctly
    func testDeletePlaces() {
        // Create a new ViewModel object
        let viewModel = PlaceViewModel()
        viewModel.addPlace(location: "Test Location", imageURL: "Test URL", locationDetails: "Test Details", latitude: 0.0, longitude: 0.0)
        // Fetch places using the ViewModel
        viewModel.fetchPlaces()
        
        // Assert that the places array in the ViewModel contains the added place
        XCTAssertEqual(viewModel.places.count, 1)

        // Delete the place using the ViewModel
        viewModel.deletePlaces(at: IndexSet(integer: 0))
        viewModel.fetchPlaces()
        
        // Assert that the places array in the ViewModel is now empty
        XCTAssertEqual(viewModel.places.count, 0)
    }
    
    
    
    // Test to check if the getImage function in the ViewModel is working correctly
    func testGetImage() async {
        // Create a new ViewModel object
        let viewModel = PlaceViewModel()
        // Define a URL for the test,get an image using the ViewModel
        let url = "https://www.shutterstock.com/image-photo/example-word-written-on-wooden-260nw-1765482248.jpg"
        _ = await viewModel.getImage(url: url)

        // Assert that the downloadImages dictionary in the ViewModel contains the URL
        XCTAssertTrue(viewModel.downloadImages.keys.contains(URL(string: url)!))
    }
}
