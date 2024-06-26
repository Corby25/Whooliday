import SwiftUI
import SafariServices

struct ProfileView: View {
    @EnvironmentObject var model: AuthModel
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showHelp = false
    @State private var showAbout = false
    @State private var showCountryPicker = false
    @State private var showCurrencyPicker = false
    @State private var showAvatarPicker = false
    @State private var showNotificationSettings = false
    @AppStorage("userAvatar") private var userAvatar = "listing-1" // Default avatar
    @State private var avatarUpdateTrigger = UUID()
    
    var body: some View {
        if let user = model.currentUser {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Spacer().frame(height: geometry.size.height * 0.05)
                    
                    // Top section with avatar and user info
                    VStack(spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Welcome, \(user.name)!")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                showAvatarPicker = true
                            }) {
                                Image(userAvatar)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                                    .id(avatarUpdateTrigger)
                            }
                        }
                    }
                    .padding()
                    
                    Spacer().frame(height: geometry.size.height * 0.05)
                    
                    // Stats section
                    VStack(spacing: 15) {
                        Text("Your Stats")
                            .font(.headline)
                            .foregroundColor(.white)
                        HStack {
                            AnimatedStatView(title: "Number of notifications we sent you:", value: user.numNotifications)
                            AnimatedStatView(title: "Number of favorites we kept track for you:", value: user.numFavorites)
                        }
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // List of settings
                    VStack(spacing: 0) {
                        ListItemButton(title: "Country", action: {
                            showCountryPicker = true
                        })
                        .sheet(isPresented: $showCountryPicker) {
                            CountryPickerView(selectedCountry: $viewModel.selectedCountry)
                        }
                        
                        ListItemButton(title: "Currency", action: {
                            showCurrencyPicker = true
                        })
                        .sheet(isPresented: $showCurrencyPicker) {
                            CurrencyPickerView(selectedCurrency: $viewModel.selectedCurrency)
                        }
                        
                        ListItemButton(title: "Notifications", action: {
                            showNotificationSettings = true
                        })
                        .sheet(isPresented: $showNotificationSettings) {
                            NotificationSettingsView(viewModel: viewModel)
                        }
                        
                        ListItemButton(title: "Help", action: {
                            showHelp = true
                        })
                        .sheet(isPresented: $showHelp) {
                            SafariView(url: URL(string: "https://example.com/help")!)
                        }
                        
                        ListItemButton(title: "About", action: {
                            showAbout = true
                        })
                        .sheet(isPresented: $showAbout) {
                            SafariView(url: URL(string: "https://example.com/about")!)
                        }
                        
                        ListItemButton(title: "Logout", action: {
                            model.signOut()
                        })
                    }
                    .background(Color.white)
                    .frame(height: geometry.size.height * 0.45)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitle("Profile", displayMode: .inline)
            .sheet(isPresented: $showAvatarPicker) {
                AvatarPickerView(selectedAvatar: $userAvatar, avatarUpdateTrigger: $avatarUpdateTrigger)
            }
            .onAppear {
                viewModel.setUser(userID: user.id)
            }
        }
    }
}

struct HelloWorldView: View {
    var body: some View {
        Text("Hello, World!")
            .font(.largeTitle)
            .padding()
    }
}

struct AnimatedStatView: View {
    let title: String
    let value: Int
    @State private var animatedValue: Double = 0
    private let animationDuration: Double = 1.0
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
            Text("\(Int(animatedValue))")
                .font(.title2)
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .onAppear {
            // Reset animatedValue to 0 before starting animation
            animatedValue = 0
            animateToValue(value)
        }
    }
    
    private func animateToValue(_ targetValue: Int) {
        let startTime = Date()
        let startValue = animatedValue
        let timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            let timeElapsed = Date().timeIntervalSince(startTime)
            if timeElapsed >= animationDuration {
                animatedValue = Double(targetValue)
                timer.invalidate()
            } else {
                let progress = timeElapsed / animationDuration
                animatedValue = startValue + Double(targetValue - Int(startValue)) * progress
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }
}

struct AnimatedStatView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedStatView(title: "Number of notifications we sent you:", value: 100)
            .background(Color.blue)
            .previewLayout(.sizeThatFits)
    }
}

struct NotificationSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Email Notifications")) {
                    Toggle("Enable Email Notifications", isOn: $viewModel.sendEmail)
                }
                
                Section(header: Text("Local Notifications")) {
                    Toggle("Enable Local Notifications", isOn: $viewModel.localNotifications)
                }
            }
            .navigationBarTitle("Notification Settings", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AvatarPickerView: View {
    @Binding var selectedAvatar: String
    @Binding var avatarUpdateTrigger: UUID
    @Environment(\.presentationMode) var presentationMode
    
    let avatars = ["listing-1", "listing-2", "listing-3", "listing-4"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                    ForEach(avatars, id: \.self) { avatar in
                        Image(avatar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(selectedAvatar == avatar ? Color.blue : Color.clear, lineWidth: 4))
                            .onTapGesture {
                                selectedAvatar = avatar
                                avatarUpdateTrigger = UUID() // Add this line
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Choose Avatar", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct CountryPickerView: View {
    @Binding var selectedCountry: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Country", selection: $selectedCountry) {
                    Text("Select Country").tag("Select Country")
                    ForEach(Country.allCountries, id: \.self) { country in
                        Text(country.name).tag(country.alpha2Code)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
            .navigationBarTitle("Select Country", displayMode: .inline)
        }
    }
}

struct CurrencyPickerView: View {
    @Binding var selectedCurrency: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Currency", selection: $selectedCurrency) {
                    Text("Select Currency").tag("Select Currency")
                    ForEach(Currency.allCurrencies, id: \.self) { currency in
                        Text(currency.name).tag(currency.code)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
            .navigationBarTitle("Select Currency", displayMode: .inline)
        }
    }
}

struct ListItemButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(title == "Logout" ? Color.red.opacity(0.1) : Color.white)
        .overlay(
            VStack {
                Spacer()
                Divider()
            }
        )
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) { }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthModel())
    }
}
