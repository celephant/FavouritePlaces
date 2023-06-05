//
//  FavouritePlacesUITests.swift
//  FavouritePlacesUITests
//
//  Created by Ze Zeng on 30/4/2023.
//

import XCTest

final class FavouritePlacesUITests: XCTestCase {
   
    // App launches correctly and displays the main screen 'Favourite Places'
    func testAppLaunches() {
        let app = XCUIApplication()
        app.launch()
        
        // Assert that the main screen is displayed
        XCTAssertTrue(app.navigationBars["Favourite Places"].exists)
    }
    
    
    
    
    // Test that tapping the "+" button opens the detail view
    func testAddPlaceOpensDetailView() {
        let app = XCUIApplication()
        app.launch()
        
        // Tap the "+" button
        app.buttons["Add"].tap()
        
        // Assert that the detail view is displayed
        XCTAssertTrue(app.staticTexts["New Location"].exists)
    }
    
}
