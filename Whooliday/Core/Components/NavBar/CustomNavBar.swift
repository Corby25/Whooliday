//
//  CustomNavBar.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI
import CoreHaptics

struct CustomNavBar: View {
    
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    @Namespace private var namespace
    
    let generator = UIImpactFeedbackGenerator(style: .soft)
    
    let tabBarItems: [(image: String, title: String)] = [
    
        ("house", "Home"),
        ("magnifyingglass", "Search"),
        ("heart", "Favorites"),
        ("person", "Profile")
        
        
        
    ]
    
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 40)
                .foregroundStyle(Color(.systemBackground))
                .shadow(radius: 6)
            
            VStack{
                HStack{
                    ForEach(0..<4) { index in

                        Button{
                            tabSelection = index + 1
                        } label: {
                            
                            
                            VStack{
                                
                                Image(systemName: tabBarItems[index].image)
                                    .foregroundStyle(.black)
                                    .font(.subheadline)
                                
                                Text(tabBarItems[index].title)
                                    .font(.footnote)
                                    .font(.system(size: 8, weight: .semibold, design:.rounded))
                                    .foregroundStyle(.black)
                            }
                            .foregroundStyle(Color(.secondarySystemBackground))
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            
                            .background(
                                ZStack{
                                    
                                    if index + 1 == tabSelection { RoundedRectangle(cornerRadius: 10)
                                            .frame(height: 40)
                                            .foregroundStyle(index + 1 == tabSelection ? Color.red.opacity(0.6): Color(.secondarySystemBackground))
                                            .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                                    }
                                })
                           
                           
                        }
                        
                        .buttonStyle(NoHighlightButtonStyle())
                        
                        
 
                    }
                    .frame(width: .infinity)
                    
                    
                  
                }
                
            }
            
            
            
            
        }
        .padding(7)
    }
        
        
}

struct NoHighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

#Preview {
    CustomNavBar(tabSelection: .constant(1))
        .previewLayout(.sizeThatFits)
        .padding(.vertical)
}


