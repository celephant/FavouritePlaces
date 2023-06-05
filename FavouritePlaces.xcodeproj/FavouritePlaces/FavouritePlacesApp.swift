//
//  FavouritePlacesApp.swift
//  FavouritePlaces
//
//  Created by Ze Zeng on 30/4/2023.
//

import SwiftUI

@main
struct FavouritePlacesApp: App {
    // Instance of PersistenceController to manage Core Data
    let persistenceController = Persistence.shared

    // Main application body
    var body: some Scene {
        WindowGroup {
            // ContentView is the main view of the application
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
