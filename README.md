# FavouritePlaces
FavouritePlaces is an iOS application developed using SwiftUI and CoreData. The application allows users to keep track of their favourite places, including detailed information and a picture.

Features
Master/Detail User Interface: The application displays a list of places in the Master View. Each entry in the list shows a thumbnail preview of the image of the place, the name of the place, and the location. The Master View is fully editable, allowing users to add, remove, and edit elements.

Detail View: Upon selecting a place from the list, the Detail View is displayed. This view provides more comprehensive information, including the image of the place, the name, the location, and any additional notes. All these elements are editable.

Interactive Maps: The Detail View includes a navigation link that displays the full information of the location, including its geographical coordinates and an interactive map. The map updates in real-time as the coordinates of the location change, and users can modify the location interactively through the map.

Online Location Services: The application uses online location services, including geo-coding, reverse geo-coding, and sunrise/sunset times. This allows users to convert between a location name and its geographical coordinates.

Testing
The application includes unit tests and UI tests performed using the XCTest framework. To run the tests, select Product > Test in Xcode.

Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
