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
                                Text(String(format: NSLocalizedString("welcome_message", comment: ""), user.name))
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
                        Text(NSLocalizedString("your_stats", comment: ""))
                            .font(.headline)
                          
                        HStack {
                            AnimatedStatView(title: NSLocalizedString("notifications_sent", comment: ""), value: user.numNotifications)
                            AnimatedStatView(title: NSLocalizedString("favorites_tracked", comment: ""), value: user.numFavorites)
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
                        ListItemButton(title: NSLocalizedString("country", comment: ""), action: {
                            showCountryPicker = true
                        })
                        .sheet(isPresented: $showCountryPicker) {
                            CountryPickerView(selectedCountry: $viewModel.selectedCountry)
                        }
                        
                        ListItemButton(title: NSLocalizedString("currency", comment: ""), action: {
                            showCurrencyPicker = true
                        })
                        .sheet(isPresented: $showCurrencyPicker) {
                            CurrencyPickerView(selectedCurrency: $viewModel.selectedCurrency)
                        }
                        
                        ListItemButton(title: NSLocalizedString("notifications", comment: ""), action: {
                            showNotificationSettings = true
                        })
                        .sheet(isPresented: $showNotificationSettings) {
                            NotificationSettingsView(viewModel: viewModel)
                        }
                        
                        ListItemButton(title: NSLocalizedString("help", comment: ""), action: {
                            showHelp = true
                        })
                        .sheet(isPresented: $showHelp) {
                            SafariView(url: URL(string: "https://example.com/help")!)
                        }
                        
                        ListItemButton(title: NSLocalizedString("about", comment: ""), action: {
                            showAbout = true
                        })
                        .sheet(isPresented: $showAbout) {
                            SafariView(url: URL(string: "https://example.com/about")!)
                        }
                        
                        ListItemButton(title: NSLocalizedString("logout", comment: ""), action: {
                            model.signOut()
                        })
                    }
                    
                    .frame(height: geometry.size.height * 0.45)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitle(NSLocalizedString("profile", comment: ""), displayMode: .inline)
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
        Text(NSLocalizedString("hello_world", comment: ""))
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
      
        .frame(maxWidth: .infinity)
        .onAppear {
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

struct NotificationSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("email_notifications", comment: ""))) {
                    Toggle(NSLocalizedString("enable_email_notifications", comment: ""), isOn: $viewModel.sendEmail)
                }
                
                Section(header: Text(NSLocalizedString("local_notifications", comment: ""))) {
                    Toggle(NSLocalizedString("enable_local_notifications", comment: ""), isOn: $viewModel.localNotifications)
                }
            }
            .navigationBarTitle(NSLocalizedString("notification_settings", comment: ""), displayMode: .inline)
            .navigationBarItems(trailing: Button(NSLocalizedString("done", comment: "")) {
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
                                avatarUpdateTrigger = UUID()
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
                .padding()
            }
            .navigationBarTitle(NSLocalizedString("choose_avatar", comment: ""), displayMode: .inline)
            .navigationBarItems(trailing: Button(NSLocalizedString("cancel", comment: "")) {
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
                Picker(NSLocalizedString("country", comment: ""), selection: $selectedCountry) {
                    Text(NSLocalizedString("select_country", comment: "")).tag("Select Country")
                    ForEach(Country.allCountries, id: \.self) { country in
                        Text(country.name).tag(country.alpha2Code)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Button(NSLocalizedString("done", comment: "")) {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
            .navigationBarTitle(NSLocalizedString("select_country", comment: ""), displayMode: .inline)
        }
    }
}

struct CurrencyPickerView: View {
    @Binding var selectedCurrency: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(NSLocalizedString("currency", comment: ""), selection: $selectedCurrency) {
                    Text(NSLocalizedString("select_currency", comment: "")).tag("Select Currency")
                    ForEach(Currency.allCurrencies, id: \.self) { currency in
                        Text(currency.name).tag(currency.code)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Button(NSLocalizedString("done", comment: "")) {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
            .navigationBarTitle(NSLocalizedString("select_currency", comment: ""), displayMode: .inline)
        }
    }
}

struct ListItemButton: View {
    let title: String
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
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
        .background(title == NSLocalizedString("logout", comment: "") ? Color.red.opacity(0.5) : (colorScheme == .dark ? .gray.opacity(0.3) : .white))
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
