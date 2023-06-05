//
//  SunriseSunsetAPI.swift
//  FavouritePlaces
//
//  Created by Ze Zeng on 26/5/2023.
//

import Foundation

// Structs to decode the API response
struct SunriseSunsetResponse: Decodable {
    let results: SunriseSunsetTimes
}

// SunriseSunsetTimes represents the sunrise and sunset times in the API response
struct SunriseSunsetTimes: Decodable {
    let sunrise: String
    let sunset: String
}

class SunriseSunsetAPI {
    // Function to fetch the sunrise and sunset times
    func getSunriseSunsetTimes(latitude: Double, longitude: Double, completion: @escaping (Result<SunriseSunsetTimes, Error>) -> Void) {
        let urlString = "https://api.sunrise-sunset.org/json?lat=\(latitude)&lng=\(longitude)&formatted=0"
        // Convert the URL string to a URL object
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        // Create a data task to fetch the data from the URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(SunriseSunsetResponse.self, from: data) {
                    // Dispatch to the main queue and call the completion handler with the decoded response
                    DispatchQueue.main.async {
                        completion(.success(decodedResponse.results))
                    }
                    return
                }
            }
            // If an error is received, dispatch to the main queue and call the completion handler with the error
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}
