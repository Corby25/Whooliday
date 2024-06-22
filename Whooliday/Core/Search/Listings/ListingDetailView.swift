//
//  ListingDetailView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI
import MapKit

struct ListingDetailView: View {

    
    @Environment(\.dismiss) var dismiss
    
    let listing: Listing
    
    var body: some View {
        ScrollView{
            ZStack(alignment: .topLeading) {
                ListingImageCarouseView(listing :listing)
                    .frame(height: 320)
                
                Button{
                    dismiss()
                }label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                        .background(){
                            Circle()
                                .fill(.white)
                                .frame(width: 32, height: 32)
                        }
                        .padding(32)
                }
            }
            
            VStack(alignment: .leading, spacing: 8){
                Text(listing.name)
                    .font(.title)
                    .fontWeight(.semibold)
                 
                VStack(alignment: .leading){
                    HStack(spacing: 2){
                        Image(systemName: "star.fill")
                        Text(String(format: "%.1f", listing.review_score))
                        Text(" - ")
                        Text("\(listing.review_count)")
                            .underline()
                            .fontWeight(.semibold)
                    }
                    .font(.caption)
                    .foregroundColor(.black)
                    
                    Text("Miami, Florida")
                }
                .font(.caption)
            }
            .padding()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
            Divider()
            
            
            // hotel info
            HStack{
                VStack(alignment: .leading, spacing: 4){
                    Text("Camera Singola")
                        .font(.headline)
                        .frame(width: 250, alignment: .leading)
                    
                    HStack{
                        Text("4 ospiti -")
                        Text("4 camere -")
                        Text("4 letti -")
                        Text("4 bagni")
                    }
                    .font(.caption)
                    
                }
                .frame(width: 300, alignment: .leading)
                Spacer()
                
                Image("portrait")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                
            }
            .padding()
            
            Divider()
            
            // listing features
            
            VStack(alignment: .leading, spacing: 16){
                ForEach(0 ..< 2){ feature in
                    HStack(spacing: 12){
                        Image(systemName: "medal")
                        
                        VStack(alignment: .leading){
                            Text("Superhost")
                                .font(.footnote)
                                .fontWeight(.semibold)
                            
                            Text("Superhost è meglio")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding()
            
            
            Divider()
            
            // rooms
            
            VStack(alignment: .leading){
                Text("Ecco dove dormirai")
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 16){
                        ForEach(1 ..< 5){ bedroom in
                            VStack{
                                Image(systemName: "bed.double")
                                Text("Bedroom  \(bedroom)")
                            }
                            .frame(width: 132, height: 100)
                            .overlay{
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
            }
            .padding()
            
            Divider()
            
            
            // listing amenities
            VStack(alignment: .leading, spacing: 16){
                Text("Cosa offre")
                    .font(.headline)
                
                ForEach(0 ..< 5){ feature in
                    HStack{
                        Image(systemName: "wifi")
                            .frame(width: 32)
                        
                        Text("Wifi")
                            .font(.footnote)
                        
                        Spacer()
                    }
                    
                }
            }
            .padding()
            
            
            Divider()
            // map view
            
            VStack(alignment: .leading, spacing: 24) {
                Text("Dove alloggerai")
                    .font(.headline)
                
                Map()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .ignoresSafeArea()
        .padding(.bottom, 64)
        .overlay(alignment: .bottom){
            VStack{
                Divider()
                    .padding(.bottom)
                
                HStack{
                    VStack(alignment: .leading){
                        Text("\(Int(listing.price))€")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("Totale prima delle tasse")
                        Text("Jun 15 - 20")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .underline()
                        
                    }
                    
                    Spacer()
                    
                    Button{
                        
                    }label: {
                        Text("Reserve")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 140, height: 40)
                            .background(.pink)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 32)
            }
            .background(.white)
        }
    }
}

#Preview {
    ListingDetailView(listing: Listing(id: 1, latitude: 0.0, longitude: 0.0, name: "Example Hotel", strikethrough_price: 199.99, review_count: 111, review_score: 8.8, images: ["https://example.com/image.jpg"]))
}


/*
 
 let id: Int
 let latitude: Double
 let longitude: Double
 let name: String
 let strikethrough_price: Double?
 let review_count: Int
 let review_score: Double
 let images: [String]
 
 var price: Double {
     strikethrough_price ?? 0
 }
 */
