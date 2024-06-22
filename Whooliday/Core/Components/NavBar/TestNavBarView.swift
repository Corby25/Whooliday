//
//  TestNavBarView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI

struct TestNavBarView: View {
    
    @State private var tabSelection = 1
    
    var body: some View {
        TabView(selection: $tabSelection){
            Text("1")
                .tag(1)
            Text("2")
                .tag(2)
            Text("3")
                .tag(3)
            Text("4")
                .tag(4)
        }
        .overlay(alignment: .bottom){
            CustomNavBar(tabSelection: $tabSelection)
        }
        
    }
}

#Preview {
    TestNavBarView()
}
