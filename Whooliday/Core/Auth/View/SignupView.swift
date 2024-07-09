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
    @EnvironmentObject var authModel: AuthModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedCountry: Country? = Country(name: "Italy", alpha2Code: "IT")
    @State private var selectedCurrency: Currency? = Currency(name: "Euro", code: "EUR")
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                logoView
                welcomeText
                inputFields
                pickers
                signupButton
                divider
                signinPrompt
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(NSLocalizedString("Error", comment: "Error alert title")),
                      message: Text(alertMessage),
                      dismissButton: .default(Text(NSLocalizedString("OK", comment: "Alert dismiss button"))))
            }
        }
    }
    
    private var logoView: some View {
        Image("logosmall")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .padding(.top, 50)
    }
    
    private var welcomeText: some View {
        Text(NSLocalizedString("Join the adventure!", comment: "Signup welcome message"))
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.primary)
    }
    
    private var inputFields: some View {
        VStack(spacing: 20) {
            CustomTextField(text: $name, placeholder: NSLocalizedString("Name", comment: "Name field placeholder"), icon: "person")
            CustomTextField(text: $email, placeholder: NSLocalizedString("Email", comment: "Email field placeholder"), icon: "envelope")
            CustomTextField(text: $password, placeholder: NSLocalizedString("Password", comment: "Password field placeholder"), icon: "lock", isSecure: true)
        }
    }
    
    private var pickers: some View {
        HStack(spacing: 20) {
            CustomPicker(selection: $selectedCountry, placeholder: NSLocalizedString("Country", comment: "Country picker label"), options: Country.allCountries)
                
            CustomPicker(selection: $selectedCurrency, placeholder: NSLocalizedString("Currency", comment: "Currency picker label"), options: Currency.allCurrencies)
        }
    }
    
    private var signupButton: some View {
        Button(action: signup) {
            Text(NSLocalizedString("Sign Up", comment: "Sign up button"))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var divider: some View {
        HStack {
            Divider().background(Color.white.opacity(0.0))
            Divider().background(Color.white.opacity(0.0))
        }
    }
    
    private var signinPrompt: some View {
        HStack {
            Text(NSLocalizedString("Already have an account?", comment: ""))
                .foregroundColor(.gray)
            NavigationLink(destination: SigninView()) {
                Text("Sign In")
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
            }
        }
        .font(.subheadline)
    }
    
    private func signup() {
        Task {
            if name.isEmpty {
                alertMessage = NSLocalizedString("Name cannot be empty, please try again", comment: "Empty name error message")
                showAlert = true
                return
            }
            
            do {
                try await authModel.signUp(withEmail: email, password: password, name: name, country: selectedCountry, currency: selectedCurrency)
            } catch {
                handleSignUpError(error)
            }
        }
    }
    
    private func handleSignUpError(_ error: Error) {
        switch (error as NSError).code {
        case 17026:
            alertMessage = NSLocalizedString("The password must be 6 characters long or more, please try again", comment: "Short password error message")
        case 17034:
            alertMessage = NSLocalizedString("An email address must be provided, please try again", comment: "Missing email error message")
        case 17008:
            alertMessage = NSLocalizedString("The email is not in the correct format, please try again", comment: "Invalid email format error message")
        case 17004, 17007:
            alertMessage = NSLocalizedString("There is already another user with this email, please try again", comment: "Duplicate email error message")
        default:
            alertMessage = NSLocalizedString("Something went wrong, please try again", comment: "Generic error message")
        }
        showAlert = true
        password = ""
    }
}

struct CustomPicker<T: Hashable & Identifiable>: View {
    @Binding var selection: T?
    let placeholder: String
    let options: [T]
    
    var body: some View {
        Picker(placeholder, selection: $selection) {
            ForEach(options) { option in
                Text(String(describing: option)).tag(option as T?)
            }
        }
        .frame(height: 20)
        .pickerStyle(MenuPickerStyle())
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
       
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView().environmentObject(AuthModel())
    }
}
