//
//  TabBarView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI
import CoreHaptics

struct TabBarView: View {
    
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    let generator = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        HStack{
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        generator.impactOccurred()
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white.ignoresSafeArea(edges: .bottom))
        
        
    }
}
    


extension TabBarView {
    private func tabView(tab: TabBarItem) -> some View {
        VStack{
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
            Text("Home")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(selection == tab ? tab.color : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(selection == tab ? tab.color.opacity(0.2) : Color.clear)
        .cornerRadius(10)
    }
    
    private func switchToTab(tab: TabBarItem){
        withAnimation(.easeInOut){
            selection = tab
        }
    }
}






#Preview {
    
    let tabs: [TabBarItem] = [
        .home, .favorites, .profile
    ]
    return VStack{
        Spacer()
        TabBarView(tabs: tabs, selection: .constant(tabs.first!))
    }
       
}
