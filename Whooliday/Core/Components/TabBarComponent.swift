//
//  TabBarComponent.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI

struct TabBarComponent: View {
    @State private var selection: String = "home"
    @State private var tabSelection: TabBarItem = .home
    
    var body: some View {
        ContainerTabBarView(selection: $tabSelection){
            Color.blue
                .tabBarItem(tab: .home, selection: $tabSelection)
            Color.red
                .tabBarItem(tab: .favorites, selection: $tabSelection)
            Color.green
                .tabBarItem(tab: .profile, selection: $tabSelection)
        }
    }
}

    
    extension TabBarComponent {
        private var defaultTabView: some View{
            TabView(selection: $selection){
                Color.red
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                Color.blue
                    .tabItem {
                        Image(systemName: "heart")
                        Text("Favorites")
                    }
                
                Color.orange
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
            }
        }
    }
    
    #Preview {
        TabBarComponent()
    }
