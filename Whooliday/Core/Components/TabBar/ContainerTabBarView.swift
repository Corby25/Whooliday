//
//  ContainerTabBarView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI

struct ContainerTabBarView<Content:View>: View {
    
    @Binding var selection: TabBarItem
    let content: Content
    
    @State private var tabs: [TabBarItem] =  [
        
    ]
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        // _ means binding
        self._selection = selection
        self.content = content() // () beacause it is a function that returns the content
    }
    
    var body: some View {
        VStack(spacing: 0){
            ZStack{
                content
            }
            TabBarView(tabs: tabs, selection: $selection)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
    
    
}

#Preview {
    let tabs: [TabBarItem] = [
        .home, .favorites, .profile
    ]
    return ContainerTabBarView(selection: .constant(tabs.first!)){
        Color.red
    }
}
