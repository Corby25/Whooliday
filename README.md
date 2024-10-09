
# Whooliday App

![Whooliday Logo](path_to_logo_image)

## Overview

Whooliday is a mobile application that transforms how travelers plan and book their stays, whether it’s a cozy apartment in a bustling city or a luxurious hotel by the beach. Whooliday makes it easy to find the perfect accommodation using powerful search tools and a user-friendly interface, allowing users to explore a wide range of hotels and apartments in their desired location.

Developed using **Swift** and **SwiftUI**, this app is built on a **three-tier client-server architecture** and integrates with various third-party services such as **Firebase**, **Google Maps API**, **Open Meteo API**, and **Firestore**.

## Features

- **Seamless Search and Comprehensive Insights**: Users can effortlessly browse through numerous accommodations with advanced filters and detailed listings that include high-quality photos and user reviews.
  
- **Detailed Price Charts for Smart Planning**: The app provides detailed price charts for each accommodation, helping users understand price trends over time and plan the best time to book.

- **Price Tracking Feature**: Users can track price changes for specific accommodations or areas, receiving real-time updates about price drops or changes.

- **Suggested Places**: Whooliday suggests popular destinations, allowing users to explore locations with additional data such as historical temperature information and user ratings.

- **Multiple Languages**: The app supports English, Italian, German, Spanish, French, and Simplified Chinese.

## Architecture

Whooliday employs the **MVVM** (Model-View-ViewModel) architectural pattern for iOS and iPadOS development. SwiftUI views handle the UI, while business logic and data handling occur through Combine framework and dependency injection.

![Architecture Diagram](path_to_architecture_image)

## Key Technologies

- **Firebase Authentication**: Securely manage user credentials and sessions.
- **Firestore**: Store user data such as preferences and favorites.
- **Google APIs**: For location-based suggestions and mapping services.
- **Custom Accommodation API**: Fetches up-to-date listings and information from the Booking.com API via RapidAPI.

## Screenshots

### Welcome Page

![Welcome Page](path_to_welcome_image)

### Home Page

![Home Page](path_to_home_image)

### Search Results

![Search Results](path_to_search_image)

### Accommodation Details

![Accommodation Details](path_to_accommodation_image)

## Testing and Integration

Whooliday features comprehensive testing:

- **Unit Tests**: Cover the core functionalities like authentication, profiles, and searches.
- **UI Tests**: Simulate user interactions with key workflows like login, search, and filtering.

With a total of 80 unit tests and 13 UI tests, the app has a coverage rate of approximately **89.5%**.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/Whooliday-App.git
   ```
2. Install dependencies:
   ```bash
   cd Whooliday-App
   pod install
   ```
3. Open the project in Xcode:
   ```bash
   open Whooliday-App.xcworkspace
   ```
4. Build and run on a simulator or connected device.

## Contributors

- **Tommaso Diegoli**
- **Fabio Tagliani**

## License

This project is licensed under the MIT License.
