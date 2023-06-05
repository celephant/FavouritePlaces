//
//  PlaceRow.swift
//  FavouritePlaces
//
//  Created by Ze Zeng on 11/5/2023.
//

import SwiftUI

struct PlaceRow: View {
    // Place object for the row
    @ObservedObject var place: Place
    // ImageLoader object to load the image for the place
    @StateObject private var imageLoader = ImageLoader()

    var body: some View {
        HStack {
            // If the image is loaded, display it, otherwise display a placeholder image
            if let image = imageLoader.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }

            // Vertical stack for the location and location details text
            VStack(alignment: .leading) {
                Text(place.location ?? "")
                    .font(.headline)
                Text(place.locationDetails ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            if let imageURL = place.imageURL {
                imageLoader.loadImage(from: imageURL)
            }
        }
        // When any property of the Place object changes, this will be called
        .onReceive(place.objectWillChange, perform: { _ in
            // This will be called whenever any property of the Place object changes,pass to masterView
        })
    }
}

// ImageLoader is a class that loads an image from a URL
class ImageLoader: ObservableObject {
    @Published var image: Image? = nil

    // Function to load an image from a URL
    func loadImage(from url: String) {
        // If the URL is not empty and is a valid URL
        guard !url.isEmpty, let imageURL = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }

        // Start a new task to load the image
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                // If the data can be converted to a UIImage
                if let uiImage = UIImage(data: data) {
                    // Update the image on the main thread
                    DispatchQueue.main.async {
                        self.image = Image(uiImage: uiImage)
                    }
                }
            } catch {
                print("Failed to load image from URL: \(url)")
            }
        }
    }
}

