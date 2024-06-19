import SwiftUI
import Firebase
import GoogleSignInSwift

@MainActor
final class AuthenticationViewModel: ObservableObject {
    func signInGoogle() async throws {
        
    }
}

struct SigninView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingSignup = false
    @EnvironmentObject var model: AuthModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
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
                
                HStack {
                    Spacer()
                    Text("Reset password")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            if email.isEmpty || !isValidEmail(email) {
                                alertMessage = "Please enter a valid email address."
                                showAlert = true
                            } else {
                                Task {
                                    do {
                                        try await model.resetPassword(email: email)
                                        alertMessage = "Password reset email sent."
                                        showAlert = true
                                    } catch {
                                        alertMessage = "Failed to send password reset email, please try again."
                                        showAlert = true
                                    }
                                }
                            }
                        }
                }
                
                Button(action: {
                    Task {
                        do {
                            try await model.signIn(withEmail: email, password: password)
                        } catch {
                            handleSignInError(error)
                        }
                    }
                }) {
                    Text("Login")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                    Task {
                        do {
                            try await model.signInGoogle()
                        } catch {
                            print(error)
                        }
                    }
                    
                }
                
                Spacer()
                
                Text("If you don't have an account yet click here to signup")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        self.showingSignup = true
                    }
                    .navigationDestination(isPresented: $showingSignup) {
                        SignupView()
                    }
            }
            .padding()
            .navigationBarTitle("Login")
            .environmentObject(model)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func handleSignInError(_ error: Error) {
        switch (error as NSError).code {
        case 17004:
            alertMessage = "Incorrect email address or password, please try again"
        case 17008:
            alertMessage = "The email is not in the correct format, please try again"
        case 17009:
            alertMessage = "The email or the password is missing, please try again"
        default:
            alertMessage = "Something went wrong, please try again"
        }
        
        // Show the alert popup
        showAlert = true
        
        // Blank the password field
        password = ""
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}


#Preview {
    SigninView()
}
