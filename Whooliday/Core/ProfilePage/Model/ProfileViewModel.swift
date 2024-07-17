import Foundation
import Firebase
import FirebaseFirestore
import Combine

class ProfileViewModel: ObservableObject {
    @Published(wrappedValue: "Select Country") var selectedCountry: String {
        didSet {
            if selectedCountry != "Select Country" {
                debounceUpdateUserLocale()
            }
        }
    }
    
    @Published(wrappedValue: "Select Currency") var selectedCurrency: String {
        didSet {
            if selectedCurrency != "Select Currency" {
                debounceUpdateUserCurrency()
            }
        }
    }
    @Published var sendEmail: Bool = false {
        didSet {
            updateUserEmailNotificationSetting(sendEmail)
        }
    }
    
    @Published var localNotifications: Bool = false {
        didSet {
            updateUserLocalNotificationSetting(localNotifications)
        }
    }
    
    private var userId: String?
    private var userListener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    private var localeUpdateSubject = PassthroughSubject<String, Never>()
    private var currencyUpdateSubject = PassthroughSubject<String, Never>()
    
    init() {
        setupDebounce()
    }
    
    func setUser(userID: String) {
        self.userId = userID
        fetchUserSettings()
    }
    
    private func setupDebounce() {
        localeUpdateSubject
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] locale in
                self?.updateUserLocale(locale)
            }
            .store(in: &cancellables)
        
        currencyUpdateSubject
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] currency in
                self?.updateUserCurrency(currency)
            }
            .store(in: &cancellables)
    }
    
    private func debounceUpdateUserLocale() {
        localeUpdateSubject.send(selectedCountry)
    }
    
    private func debounceUpdateUserCurrency() {
        currencyUpdateSubject.send(selectedCurrency)
    }
    
    func updateUserLocale(_ locale: String) {
        guard let userId = userId else { return }
        Firestore.firestore().collection("users").document(userId).updateData(["locale": locale])
    }
    
    func updateUserCurrency(_ currency: String) {
        guard let userId = userId else { return }
        Firestore.firestore().collection("users").document(userId).updateData(["currency": currency])
    }
    
    private func fetchUserSettings() {
        guard let userId = userId else { return }
        userListener = Firestore.firestore().collection("users").document(userId).addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching user settings: \(error.localizedDescription)")
                return
            }
            guard let data = snapshot?.data(),
                  let locale = data["locale"] as? String,
                  let currency = data["currency"] as? String,
                  let sendEmail = data["sendEmail"] as? Bool else { return }
            
            DispatchQueue.main.async {
                self?.selectedCountry = locale
                self?.selectedCurrency = currency
                self?.sendEmail = sendEmail
            }
        }
    }
    
    func updateUserEmailNotificationSetting(_ value: Bool) {
        guard let userId = userId else { return }
        Firestore.firestore().collection("users").document(userId).updateData(["sendEmail": value]) { error in
            if let error = error {
                print("Error updating email notification setting: \(error.localizedDescription)")
            } else {
                print("Email notification setting updated successfully")
            }
        }
    }
    
    // not available now beacuse it requires AppleDeveloperAccount
    func updateUserLocalNotificationSetting(_ value: Bool) {
        /*guard let userId = userId else { return }
         Firestore.firestore().collection("users").document(userId).updateData(["localNotifications": value]) { error in
         if let error = error {
         print("Error updating local notification setting: \(error.localizedDescription)")
         } else {
         print("Local notification setting updated successfully")
         }
         }*/
    }
    
    deinit {
        userListener?.remove()
    }
}
