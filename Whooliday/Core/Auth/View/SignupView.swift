//
//  SwiftUIView.swift
//  Whooliday
//
//  Created by Tommaso Diegoli on 19/06/24.
//

import SwiftUI

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @EnvironmentObject var model: AuthModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Array of countries
    let countries = Country.allCountries
    
    // Selected country and currency
    @State private var selectedCountry: Country? = Country(name: "Italy", alpha2Code: "IT")
    @State private var selectedCurrency: Currency? = Currency(name: "Euro", code: "EUR") // Default currency
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .autocapitalization(.words)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
            
            // Country picker
            Picker("Country", selection: $selectedCountry) {
                ForEach(countries, id: \.self) { country in
                    Text(country.name).tag(country as Country?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5.0)
            
            // Currency picker
            Picker("Currency", selection: $selectedCurrency) {
                ForEach(Currency.allCurrencies, id: \.self) { currency in
                    Text("\(currency.code) - \(currency.name)").tag(currency as Currency?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5.0)
            
            Button(action: {
                Task {
                    if name.isEmpty {
                        alertMessage = "Name cannot be empty, please try again"
                        showAlert = true
                        return
                    }
                    
                    do {
                        // Sign up with email, password, name, selectedCountry, and selectedCurrency
                        try await model.signUp(withEmail: email, password: password, name: name, country: selectedCountry, currency: selectedCurrency)
                    } catch {
                        handleSignUpError(error)
                    }
                }
            }) {
                Text("Signup")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(5.0)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Signup", displayMode: .inline)
        .environmentObject(model)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func handleSignUpError(_ error: Error) {
        switch (error as NSError).code {
        case 17026:
            alertMessage = "The password must be 6 characters long or more, please try again"
        case 17034:
            alertMessage = "An email address must be provided, please try again"
        case 17008:
            alertMessage = "The email is not in the correct format, please try again"
        case 17004, 17007:
            alertMessage = "There is already another user with this email, please try again"
        default:
            alertMessage = "Something went wrong, please try again"
        }
        
        // Show the alert popup
        showAlert = true
        
        // Blank the password field
        password = ""
    }
}
