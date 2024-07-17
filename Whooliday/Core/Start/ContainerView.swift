import SwiftUI

struct ContainerView: View {
    
    @EnvironmentObject var model: AuthModel
    @State private var isFirstLaunch: Bool
    
    // Custom initializer
    init() {
        // Check if the app has been launched before
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        // If it has, set `isFirstLaunch` to false, otherwise true
        if hasLaunchedBefore {
            _isFirstLaunch = State(initialValue: false)
        } else {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            _isFirstLaunch = State(initialValue: true)
        }
    }
    
    var body: some View {
        Group {
            if isFirstLaunch {
                WelcomeView1(isFirstLaunch: $isFirstLaunch)
            } else {
                if model.userSession != nil {
                    ContentView() // Show the navigation bar with tab views
                } else {
                    ContentViewNoLogged();
                }
            }
        }.accessibilityIdentifier("ContainerView")
    }
    
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text(NSLocalizedString("Favorites", comment: ""))
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text(NSLocalizedString("Profile", comment: ""))
                }
        }
    }
}


struct ContentViewNoLogged: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                    
                }
            
            
            SigninView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Login")
                }
            
            
        }
    }
}



